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
#>
param(
# The File Path to Include
[Parameter(Mandatory,Position=0)]
[string]
$FilePath,

# If set, will include the content as a byte array
[switch]
$AsByte,

[Parameter(Mandatory,ParameterSetName='VariableAST', ValueFromPipeline)]
[Management.Automation.Language.VariableExpressionast]
$VariableAst
)

$includingCommand = $ExecutionContext.SessionState.InvokeCommand.GetCommand($FilePath, 'All')
if (-not $includingCommand) {
    Write-Error "Could not resolve $($FilePath)"
    return
}

function IncludeFileContents {
    param($FilePath)
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

$includedScript, $assignable = 
    if ($includingCommand -is [Management.Automation.CmdletInfo]) {
        Write-Error "Cannot Include Cmdlets"
        return
    }
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
}
"@)
        }        
    } elseif ($includingCommand.ScriptBlock) {
        # If we're including a command with a ScriptBlock, assign it to a variable
        [ScriptBlock]::Create(@"
`${$($includingCommand.Name)} =  {
    $($includingCommand.ScriptBlock)
}
"@)
        
    } 
    elseif ($includingCommand.Source -match '\.ps1{0,}\.(?<ext>[^.]+$)') {
        $transpiledFile = Invoke-PipeScript -CommandInfo $includingCommand
        if (-not $transpiledFile) {
            Write-Error "Could not transpile $($includingCommand.Source)"
            return
        }
        IncludeFileContents $transpiledFile.Fullname
    }
    elseif ($includingCommand.Source -match '\.ps$') {
        [ScriptBlock]::Create(@"
`${$($includingCommand.Name)} =  {
    $([ScriptBlock]::Create([IO.File]::ReadAllText($includingCommand.Source)) | .<PipeScript>)
}
"@)
        
    } else {
        IncludeFileContents $includingCommand.Source    
    }

if ($psCmdlet.ParameterSetName -eq 'ScriptBlock' -or 
    $VariableAst.VariablePath -match '^null$') {
    if ($ScriptBlock -and $ScriptBlock.ToString().Length) {
        [ScriptBlock]::Create("$ScriptBlock" + [Environment]::NewLine + $includedScript)
    } else {
        $includedScript
    }
    
} elseif ($VariableAst.VariablePath) {    
    [ScriptBlock]::Create("$($VariableAst.VariablePath) = $IncludedScript")
}
