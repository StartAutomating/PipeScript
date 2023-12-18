
describe 'Protocol.HTTP' {
    it 'Protocol.HTTP Example 1' {
        .> {
            https://api.github.com/repos/StartAutomating/PipeScript
        }
    }
    it 'Protocol.HTTP Example 2' {
        {
            get https://api.github.com/repos/StartAutomating/PipeScript
        } | .>PipeScript
    }
    it 'Protocol.HTTP Example 3' {
        Invoke-PipeScript {
            $GitHubApi = 'api.github.com'
            $UserName  = 'StartAutomating'
            https://$GitHubApi/users/$UserName
        }
    }
    it 'Protocol.HTTP Example 4' {
        .> -ScriptBlock {
            https://$GitHubApi/users/$UserName -GitHubApi api.github.com -UserName StartAutomating
        }
    }
    it 'Protocol.HTTP Example 5' {
        .> -ScriptBlock {
            https://$GitHubApi/users/$UserName -GitHubApi api.github.com -UserName StartAutomating
        }
    }
    it 'Protocol.HTTP Example 6' {
        .> -ScriptBlock {
            @(foreach ($repo in https://api.github.com/users/StartAutomating/repos?per_page=100) {
                $repo | .Name .Stars { $_.stargazers_count }
            }) | Sort-Object Stars -Descending
        }
    }
    it 'Protocol.HTTP Example 7' {
        $semanticAnalysis = 
            Invoke-PipeScript {
                http://text-processing.com/api/sentiment/ -Method POST -ContentType 'application/x-www-form-urlencoded' -Body "text=amazing!" |
                    Select-Object -ExpandProperty Probability -Property Label
            }

        $semanticAnalysis
    }
    it 'Protocol.HTTP Example 8' {
        $statusHealthCheck = {
            [Https('status.dev.azure.com/_apis/status/health')]
            param()
        } | Use-PipeScript

        & $StatusHealthCheck
    }
}

