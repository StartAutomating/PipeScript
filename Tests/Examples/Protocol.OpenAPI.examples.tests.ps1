
describe 'Protocol.OpenAPI' {
    it 'Protocol.OpenAPI Example 1' {
        # We can easily create a command that talks to a single REST api described in OpenAPI.
        Import-PipeScript {
            function Get-GitHubIssue
            {
                [OpenAPI(SchemaURI=
                    'https://raw.githubusercontent.com/github/rest-api-description/main/descriptions/api.github.com/api.github.com.json#/repos/{owner}/{repo}/issues/get')]    
                param()
            }
        }

        Get-GitHubIssue -Owner StartAutomating -Repo PipeScript
    }
    it 'Protocol.OpenAPI Example 2' {
        # We can also make a general purpose command that talks to every endpoint in a REST api.
        Import-PipeScript {
            function GitHubApi
            {
                [OpenAPI(SchemaURI='https://raw.githubusercontent.com/github/rest-api-description/main/descriptions/api.github.com/api.github.com.json')]
                param()
            }
        }

        GitHubApi '/zen'
    }
    it 'Protocol.OpenAPI Example 3' {
        # We can also use OpenAPI as a command.  Just pass a URL, and get back a script block.
        openapi https://raw.githubusercontent.com/openai/openai-openapi/master/openapi.yaml#/models/get
    }
    it 'Protocol.OpenAPI Example 4' {
        $TranspiledOpenAPI = { openapi https://raw.githubusercontent.com/openai/openai-openapi/master/openapi.yaml#/models/get } |
            Use-PipeScript
        & $TranspiledOpenAPI |  Should -BeOfType ([ScriptBlock])
    }
}

