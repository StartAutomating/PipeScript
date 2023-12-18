
function Protocol.HTTP {

    <#
    .SYNOPSIS
        HTTP protocol
    .DESCRIPTION
        Converts an http(s) protocol commands to PowerShell.
    .EXAMPLE
        .> {
            https://api.github.com/repos/StartAutomating/PipeScript
        }
    .EXAMPLE
        {
            get https://api.github.com/repos/StartAutomating/PipeScript
        } | .>PipeScript
    .EXAMPLE
        Invoke-PipeScript {
            $GitHubApi = 'api.github.com'
            $UserName  = 'StartAutomating'
            https://$GitHubApi/users/$UserName
        }
    .EXAMPLE
        .> -ScriptBlock {
            https://$GitHubApi/users/$UserName -GitHubApi api.github.com -UserName StartAutomating
        }
    .EXAMPLE
        .> -ScriptBlock {
            https://$GitHubApi/users/$UserName -GitHubApi api.github.com -UserName StartAutomating
        }
    .EXAMPLE
        .> -ScriptBlock {
            @(foreach ($repo in https://api.github.com/users/StartAutomating/repos?per_page=100) {
                $repo | .Name .Stars { $_.stargazers_count }
            }) | Sort-Object Stars -Descending
        }
    .EXAMPLE
        $semanticAnalysis = 
            Invoke-PipeScript {
                http://text-processing.com/api/sentiment/ -Method POST -ContentType 'application/x-www-form-urlencoded' -Body "text=amazing!" |
                    Select-Object -ExpandProperty Probability -Property Label
            }

        $semanticAnalysis
    .EXAMPLE
        $statusHealthCheck = {
            [Https('status.dev.azure.com/_apis/status/health')]
            param()
        } | Use-PipeScript

        & $StatusHealthCheck
    #>
    [ValidateScript({
        $commandAst = $_
        if ($commandAst -isnot [Management.Automation.Language.CommandAst]) { return $false }
        # If neither command element contained a URI
        if (-not ($commandAst.CommandElements[0..1].Value -match '^https{0,1}://')) {
            return $false # return false
        }
        
        # If the first element is not the URI
        if ($commandAst.CommandElements[0].Value -notmatch '^https{0,1}://')  {
            # then we are only valid if the first element is a WebRequestMethod
            return $commandAst.CommandElements[0].Value -in (
                [Enum]::GetValues([Microsoft.PowerShell.Commands.WebRequestMethod]) -ne 'Default'
            )
        }

        # If we're here, then the first element is a HTTP uri, 
        return $true # so we return true.
    })]
    [Alias('HTTP','HTTPS')]    
    param(
    # The URI.
    [Parameter(Mandatory,ValueFromPipeline,Position=0,ParameterSetName='Protocol')]
    [Parameter(Mandatory,ValueFromPipeline,Position=0,ParameterSetName='Interactive')]
    [Parameter(Mandatory,ParameterSetName='ScriptBlock',Position=0)]
    [uri]
    $CommandUri,

    # The Command's Abstract Syntax Tree
    [Parameter(Mandatory,ParameterSetName='Protocol')]
    [Management.Automation.Language.CommandAST]
    $CommandAst,

    [Parameter(Mandatory,ValueFromPipeline,ParameterSetName='ScriptBlock')]
    [ScriptBlock]
    $ScriptBlock = {},

    # Any remaining arguments.  These will be passed positionally to the invoker.
    [Parameter(ValueFromRemainingArguments)]
    $ArgumentList = @(),

    # Any named parameters for the invoker.
    [Parameter(ValueFromRemainingArguments)]
    [Collections.IDictionary]
    $Parameter = @{},

    # The HTTP method.  By default, get.
    [string]
    $Method = 'GET',

    # The invocation command.  By default, Invoke-RestMethod.
    # Whatever alternative command provided should have a similar signature to Invoke-RestMethod.
    [string]
    $Invoker = 'Invoke-RestMethod'
    )

    process {

        if (-not $commandUri.Scheme) {
            $uriScheme = 
                if ($MyInvocation.InvocationName -eq 'http') {
                    'http'   
                } else {
                    'https'
                }
            $commandUri = [uri]"${uriScheme}://$($commandUri.OriginalString -replace '://')"
        }

        if ($PSCmdlet.ParameterSetName -eq 'Protocol') {

            $commandArguments  = @() + $CommandAst.ArgumentList
            $commandParameters = [Ordered]@{} + $CommandAst.Parameter
            $offset = 1
            if ($Method -and $CommandAst -match "^$Method") {
                $offset = 2
            }
            # we will parse our input as a sentence.
            $mySentence = $commandAst.AsSentence($MyInvocation.MyCommand,$offset)
            # Walk thru all mapped parameters in the sentence
            $myParams = [Ordered]@{} + $PSBoundParameters
            foreach ($paramName in $mySentence.Parameters.Keys) {
                if (-not $myParams.Contains($paramName)) { # If the parameter was not directly supplied
                    $myParams[$paramName] = $mySentence.Parameters[$paramName] # grab it from the sentence.
                    foreach ($myParam in $myCmd.Parameters.Values) {
                        if ($myParam.Aliases -contains $paramName) { # set any variables that share the name of an alias
                            $ExecutionContext.SessionState.PSVariable.Set($myParam.Name, $mySentence.Parameters[$paramName])
                        }
                    }
                    # set this variable for this value.
                    $ExecutionContext.SessionState.PSVariable.Set($paramName, $mySentence.Parameters[$paramName])                    
                }
            }

            $method      = ''
            $commandName =         
                if ($CommandAst.CommandElements[0].Value -match '://') {
                    $commandAst.CommandElements[0].Value
                } else {
                    $method = $commandAst.CommandElements[0].Value
                    $commandArguments = $commandArguments[2..($commandArguments.Count + 1)]
                    $commandAst.CommandElements[1].Value
                }        
            
            $startIndex = 0
            $partsToJoin = 
                @(
                    foreach ($match in [Regex]::Matches(
                        $commandName, '(?>
                            (?<Variable>\$\w+\:\w+)
                            |
                            (?<Variable>\$\w+)
                            )', 
                            'IgnoreCase, IgnorePatternWhitespace'
                        )
                    ) {
                        "'" + 
                            $commandName.Substring($startIndex, $match.Index - $startIndex).Replace("'", "''") + 
                        "'"
                        $varMatch = $match.Groups["Variable"].Value
                        $varName  = $varMatch.TrimStart('$')
                        if ($commandParameters[$varName]) {
                            $varParameter = $commandParameters[$varName]
                            $commandParameters.Remove($varName)
                            if ($varParameter -is [string]) {
                                "'" + $varParameter + "'"
                            }
                            elseif ($varParameter -is [ScriptBlock]) {
                                "{$varParameter}"
                            } else {
                                $varParameter
                            }
                        } else {
                            $varMatch
                        }
                        
                        $startIndex = $match.Index + $match.Length        
                    }
                    "'" + 
                        $commandName.Substring($startIndex).Replace("'", "''") + 
                    "'"
                )
                
                $newScript = 
                if ($partsToJoin.Count -gt 1) {
                    "$Invoker ($($PartsToJoin -join ',') -join '')$(if ($method) {" -Method '$Method'"})"
                } else {
                    "$Invoker $PartsToJoin$(if ($method) {" -Method '$Method'"})"
                }
            $newScript += @(
                foreach ($argument in $commandArguments) {
                    if ($argument -is [string]) {
                        "'" + $argument.Replace("'", "''") + "'"
                    }
                    elseif ($argument -is [scriptblock]) {
                        "{" + $argument + "}"
                    } else {
                        "$argument"
                    }
                }
                foreach ($param in $commandParameters.GetEnumerator()) {
                    if ($param.Value -isnot [bool]) {
                        "-$($param.Key)"
                    }
    
                    if ($param.Value -is [string]) {
                        "'" + $param.Value.Replace("'", "''") + "'"
                    }
                    elseif ($param.Value -is [ScriptBlock]) {
                        "{" + $param.Value + "}"
                    }
                    elseif ($param.Value -is [bool]) {
                        if ($param.Value) {
                            "-$($param.Key)"        
                        } else {
                            "-$($param.Key):`$false"
                        }
                    }
                    else {
                        $param.Value
                    }
                }
            ) -join ' '

            [scriptblock]::Create($newScript)
        }
        elseif ($psCmdlet.ParameterSetName -eq 'ScriptBlock') {
            if (-not $scriptBlock.Ast.ParamBlock.Parameters.Count -and 
                -not $scriptBlock.Ast.EndBlock.Statements.Count) {
                
                [scriptblock]::Create("
                $Invoker '$CommandUri'$(if ($method) {" -Method '$Method'"})
                ")                
            }
            
        }
        elseif ($psCmdlet.ParameterSetName -eq 'Interactive') {
            
            if ($Method -and -not $parameter.Method) {
                $parameter.Method = $method
            }
            & $Invoker $commandUri @ArgumentList @Parameter
        }
    }


}

