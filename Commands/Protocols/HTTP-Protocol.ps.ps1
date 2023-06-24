<#
.SYNOPSIS
    http protocol
.DESCRIPTION
    Converts an http[s] protocol command to PowerShell.
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
    .> {
        http://text-processing.com/api/sentiment/ -Method POST -ContentType 'application/x-www-form-urlencoded' -Body "text=amazing!" |
            Select-Object -ExpandProperty Probability -Property Label
    }
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
param(
# The URI.
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='Protocol')]
[uri]
$CommandUri,

# The Command's Abstract Syntax Tree
[Parameter(Mandatory,ParameterSetName='Protocol')]
[Management.Automation.Language.CommandAST]
$CommandAst,

# The HTTP method.  By default, get.
[string]
$Method = 'GET'
)

process {
    $commandArguments  = @() + $CommandAst.ArgumentList
    $commandParameters = [Ordered]@{} + $CommandAst.Parameter

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
    
    $invoker = "Invoke-RestMethod"
    if ($commandParameters.Invoker) {
        $invoker = "$($commandParameters.Invoker)"
        $commandParameters.Remove('Invoker')
    }
    
    if ($method) {
        $commandParameters.Method = $method
    }

    
    $newScript = 
        if ($partsToJoin.Count -gt 1) {
            "$Invoker ($($PartsToJoin -join ',') -join '') "
        } else {
            "$Invoker $PartsToJoin "
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
