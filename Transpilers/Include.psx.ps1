<#
.SYNOPSIS
    Includes Files
.DESCRIPTION
    Includes Files or Functions into a Script.
.Example
    {
        [Include("Invoke-PipeScript")]$null
    } | .>PipeScript
.Example
    {
        [Include("Invoke-PipeScript")]
        param()
    } | .>PipeScript
.EXAMPLE
    {
        [Include('*-*.ps1')]$psScriptRoot
    } | .>PipeScript
.EXAMPLE
    {
        [Include('https://pssvg.start-automating.com/Examples/PowerShellChevron.svg')]$PSChevron
    } | .>PipeScript
#>
[ValidateScript({    
    $validating = $_    
    if ($validating -is [Management.Automation.Language.CommandAst]) {
        return $validating.CommandElements[0].Value -in 'include','includes'
    }
})]
[Alias('Includes')]
param(
# The File Path to Include
[Parameter(Mandatory,ParameterSetName='VariableAST',Position=0)]
[Parameter(ParameterSetName='CommandAst',Position=0)]
[Alias('FullName','Uri','Url')]
[string]
$FilePath,

# If set, will include the content as a byte array
[switch]
$AsByte,

# If set, will pass thru the included item
[switch]
$Passthru,

# The exclusion pattern to use.
[Alias('ExcludePattern')]
[string[]]
$Exclude = '\.[^\.]+\.ps1$',

# The variable that include will be applied to.
# If including files with wildcards, this will be the base path.
# Otherwise, this variable will be assigned to the included value.
[Parameter(Mandatory,ParameterSetName='VariableAST', ValueFromPipeline)]
[Management.Automation.Language.VariableExpressionast]
$VariableAst,


# The CommandAST.
# This is provided by the transpiler when include is used as a keyword.
[Parameter(Mandatory,ParameterSetName='CommandAst',ValueFromPipeline)]
[Management.Automation.Language.CommandAst]
$CommandAst
)

process {

    if ($psCmdlet.ParameterSetName -eq 'CommandAst') {
        # Gather some information about our calling context
        $myParams = [Ordered]@{} + $PSBoundParameters
        # and attempt to parse it as a sentance (only allowing it to match this particular command)
        $mySentence = $commandAst.AsSentence($MyInvocation.MyCommand)
        $myCmd = $MyInvocation.MyCommand

        # Walk thru all mapped parameters in the sentence
        foreach ($paramName in $mySentence.Parameters.Keys) {
            if (-not $myParams[$paramName]) { # If the parameter was not directly supplied
                $myParams[$paramName] = $mySentence.Parameters[$paramName] # grab it from the sentence.
                foreach ($myParam in $myCmd.Parameters.Values) {
                    if ($myParam.Aliases -contains $paramName) { # set any variables that share the name of an alias
                        $ExecutionContext.SessionState.PSVariable.Set($myParam.Name, $mySentence.Parameters[$paramName])
                    }
                }
                # and set this variable for this value.
                $ExecutionContext.SessionState.PSVariable.Set($paramName, $mySentence.Parameters[$paramName])
            }
        }

        if ($mySentence.ArgumentList -and -not $FilePath) {
            $FilePath = $mySentence.ArgumentList[0]
        }
    }

# Determine the command we would be including (relative to the current path)
$includingCommand = $ExecutionContext.SessionState.InvokeCommand.GetCommand($FilePath, 'All')
if (-not $includingCommand) { # if we could not determine the command, we may need to error out.
    if ($FilePath -match '^https?://') {
        $includingUrl = $FilePath -as [uri] 
    } else {
        if (-not $FilePath.Contains('*')) {
            Write-Error "Could not resolve $($FilePath).  Must be a command, path, or URI."
            return
        }
    }
}

function IncludeFileContents {
    param($FilePath)
    process {
    if ($AsByte) {
        [ScriptBlock]::Create(
        "@'" + [Environment]::NewLine + 
        [Convert]::ToBase64String(
            [IO.File]::ReadAllBytes($FilePath),
            'InsertLineBreaks'
        ) + [Environment]::NewLine + 
        "'@")
    
    } else {
        [ScriptBlock]::Create(
        "@'" + 
            [Environment]::NewLine + 
            ([IO.File]::ReadAllLines($FilePath) -replace "^@'", "@''" -replace "^'@", "''@" -join [Environment]::NewLine) +
            [Environment]::NewLine + 
        "'@" + @'
-split "[\r\n]{1,2}" -replace "^@''", "@'" -replace "^''@", "'@" -join [Environment]::NewLine
'@
        )    
    }
    }
}

#region Generate the Include Script

$includeTemplate = 
    if ($includingCommand.Include) {
        $includingCommand.Include
    } elseif ($includingCommand.Module.Include) {
        $includingCommand.Module.Include
    }

# We cannot include cmdlets
if ($includingCommand -is [Management.Automation.CmdletInfo] -and -not $includeTemplate) {
    Write-Error "Cannot Include Cmdlets"
    return
}

$includedScript =
    # If there was a include method
    if ($includeTemplate -is [Management.Automation.PSMethodInfo]) {
        # use that.
        $includeTemplate.Invoke(@($includingCommand))
    }
    elseif ($includeTemplate -is [scriptblock]) {
        & $includeTemplate $includingCommand
    }
    # We can include functions without any difficulty        
    elseif ($includingCommand -is [Management.Automation.FunctionInfo]) {
        if ($VariableAst -and $VariableAst.VariablePath -notmatch '^null$') {
            # If we're including a function as a variable, define it as a ScriptBlock
[ScriptBlock]::Create(@"
{
    $($includingCommand.ScriptBlock)
}
"@)
        } else {
            # If we're including a function, define it inline
        [ScriptBlock]::Create(@"
function $($includingCommand.Name) {
    $($includingCommand.ScriptBlock)
}$(
if ($Passthru) {
    [Environment]::NewLine +
        "`$executionContext.SessionState.InvokeCommand.GetCommand(`"$($includingCommand.Name)`",'Function')"
})
"@)
        }        
    } 
    elseif ($includingCommand.ScriptBlock)
    {
        # If we're including a command with a ScriptBlock, assign it to a variable
        [ScriptBlock]::Create(@"
`${$($includingCommand.Name)} =  {
    $($includingCommand.ScriptBlock)
}$(
if ($Passthru) { [Environment]::NewLine + "`${$($includingCommand.Name)}"}
)
"@)
        
    } 
    elseif (
        $includingCommand.Source -match '\.ps1{0,}\.(?<ext>[^.]+$)'
    ) {
        $compiledFile = Invoke-PipeScript -CommandInfo $includingCommand
        if (-not $compiledFile) {
            Write-Error "Could not transpile $($includingCommand.Source)"
            return
        }
        IncludeFileContents $compiledFile.Fullname
    }
    elseif (
        $includingCommand.Source -match '\.ps$'
    ) {
        [ScriptBlock]::Create(@"
`${$($includingCommand.Name)} =  {
    $([ScriptBlock]::Create([IO.File]::ReadAllText($includingCommand.Source)) | .>PipeScript)
}$(
if ($Passthru) { [Environment]::NewLine + "`${$($includingCommand.Name)}"}
)
"@)
        
    } elseif ($includingCommand) {
        IncludeFileContents $includingCommand.Source    
    }
    elseif ($includingUrl) {
        $webResponse = Invoke-WebRequest -Uri $includingUrl
        if ($webResponse.Content -is [string]) {
            $restResponse = Invoke-RestMethod -Uri $includingUrl
            if (
                (
                    ($restResponse -is [PSObject]) -or 
                    ($restResponse -is [Object[]])
                ) -and (
                    -not ($webResponse.Content -as [xml])
                ) -and (
                    $restResponse -isnot [string]
                )
            ) {
                [ScriptBlock]::Create((@(
                    "@'"
                    $($restResponse | ConvertTo-Json -Depth 100)
                    "'@ |"
                    "    ConvertFrom-JSON"
                ) -join [Environment]::NewLine))
            }             
            else {
                if ($restResponse -is [string] -and $(
                    $restScript = try { [scriptblock]::Create($restResponse) } catch { $null }
                    $restScript
                )) {
                    $restScript
                }
                else {
                    [ScriptBlock]::Create((@(
                        "$(if ($webResponse.Content -as [xml]) { '[xml]'})@'"
                        $(if ($restResponse -is [xml]) { $restResponse.OuterXML } else { $restResponse })
                        "'@"                        
                    ) -join [Environment]::NewLine))
                }
            }
        } elseif ($webResponse.Content -is [byte[]]) {
            [ScriptBlock]::Create(
                "@'" + [Environment]::NewLine + 
                [Convert]::ToBase64String(
                    $webResponse.Content,
                    'InsertLineBreaks'
                ) + [Environment]::NewLine + 
                "'@")
        }
    }
#endregion Generate the Include Script

if ($psCmdlet.ParameterSetName -eq 'ScriptBlock' -or 
    $VariableAst.VariablePath -match '^null$') {
    if ($ScriptBlock -and $ScriptBlock.ToString().Length) {
        [ScriptBlock]::Create("$ScriptBlock" + [Environment]::NewLine + $includedScript)
    } else {
        $includedScript
    }
    
} elseif ($VariableAst.VariablePath -and $IncludedScript) {    
    [ScriptBlock]::Create("$($VariableAst) = $IncludedScript")
} 
elseif ($CommandAst) {
    $IncludedScript
}
elseif ($VariableAst.VariablePath -notmatch '^null$') {
    [ScriptBlock]::Create(@"
:ToIncludeFiles foreach (`$file in (Get-ChildItem -Path "$($VariableAst)" -Filter "$FilePath" -Recurse)) {
    if (`$file.Extension -ne '.ps1')      { continue }  # Skip if the extension is not .ps1
    foreach (`$exclusion in '$($Exclude -replace "'","''" -join "','")') {
        if (-not `$exclusion) { continue }
        if (`$file.Name -match `$exclusion) {
            continue ToIncludeFiles  # Skip excluded files
        }
    }     
    . `$file.FullName$(
    if ($Passthru) { [Environment]::NewLine + (' ' * 4) + '$file'}
    )
}
"@)
}

}