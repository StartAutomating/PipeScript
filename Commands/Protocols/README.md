## Protocols in PipeScript

```https://api.github.com/repos/StartAutomating/PipeScript/issues``` is a valid command.

So is ```get https://api.github.com/repos/StartAutomating/PipeScript/issues```.
    
So is ```MyCustomProtocol:// -Parameter value```.

PipeScript supports transpiling protocols.

Any command where :// appears in it's first two elements will be considered a potential protocol.


|Name                                               |Synopsis                                            |
|---------------------------------------------------|----------------------------------------------------|
|[Protocol.HTTP](/docs/Protocol.HTTP.md)            |[HTTP protocol](/docs/Protocol.HTTP.md)             |
|[Protocol.JSONSchema](/docs/Protocol.JSONSchema.md)|[JSON Schema protocol](/docs/Protocol.JSONSchema.md)|
|[Protocol.OpenAPI](/docs/Protocol.OpenAPI.md)      |[OpenAPI protocol](/docs/Protocol.OpenAPI.md)       |
|[Protocol.UDP](/docs/Protocol.UDP.md)              |[UDP protocol](/docs/Protocol.UDP.md)               |



## Protocol Examples

All of the current protocol examples are listed below:

##  Example 1


~~~PowerShell
        .> {
            https://api.github.com/repos/StartAutomating/PipeScript
        }
~~~

##  Example 2


~~~PowerShell
        {
            get https://api.github.com/repos/StartAutomating/PipeScript
        } | .>PipeScript
~~~

##  Example 3


~~~PowerShell
        Invoke-PipeScript {
            $GitHubApi = 'api.github.com'
            $UserName  = 'StartAutomating'
            https://$GitHubApi/users/$UserName
        }
~~~

##  Example 4


~~~PowerShell
        .> -ScriptBlock {
            https://$GitHubApi/users/$UserName -GitHubApi api.github.com -UserName StartAutomating
        }
~~~

##  Example 5


~~~PowerShell
        .> -ScriptBlock {
            https://$GitHubApi/users/$UserName -GitHubApi api.github.com -UserName StartAutomating
        }
~~~

##  Example 6


~~~PowerShell
        .> -ScriptBlock {
            @(foreach ($repo in https://api.github.com/users/StartAutomating/repos?per_page=100) {
                $repo | .Name .Stars { $_.stargazers_count }
            }) | Sort-Object Stars -Descending
        }
~~~

##  Example 7


~~~PowerShell
        $semanticAnalysis = 
            Invoke-PipeScript {
                http://text-processing.com/api/sentiment/ -Method POST -ContentType 'application/x-www-form-urlencoded' -Body "text=amazing!" |
                    Select-Object -ExpandProperty Probability -Property Label
            }

        $semanticAnalysis
~~~

##  Example 8


~~~PowerShell
        $statusHealthCheck = {
            [Https('status.dev.azure.com/_apis/status/health')]
            param()
        } | Use-PipeScript

        & $StatusHealthCheck
~~~

##  Example 1


~~~PowerShell
        jsonschema https://aka.ms/terminal-profiles-schema#/$defs/Profile
~~~

##  Example 2


~~~PowerShell
        {
            [JSONSchema(SchemaURI='https://aka.ms/terminal-profiles-schema#/$defs/Profile')]
            param()
        }.Transpile()
~~~

##  Example 1


~~~PowerShell
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
~~~

##  Example 2


~~~PowerShell
        # We can also make a general purpose command that talks to every endpoint in a REST api.
        Import-PipeScript {
            function GitHubApi
            {
                [OpenAPI(SchemaURI='https://raw.githubusercontent.com/github/rest-api-description/main/descriptions/api.github.com/api.github.com.json')]
                param()
            }
        }

        GitHubApi '/zen'
~~~

##  Example 3


~~~PowerShell
        # We can also use OpenAPI as a command.  Just pass a URL, and get back a script block.
        openapi https://raw.githubusercontent.com/openai/openai-openapi/master/openapi.yaml#/models/get
~~~

##  Example 4


~~~PowerShell
        $TranspiledOpenAPI = { openapi https://raw.githubusercontent.com/openai/openai-openapi/master/openapi.yaml#/models/get } |
            Use-PipeScript
        & $TranspiledOpenAPI # Should -BeOfType ([ScriptBlock])
~~~

##  Example 1


~~~PowerShell
    # Creates the code to create a UDP Client
    {udp://127.0.0.1:8568} | Use-PipeScript
~~~

##  Example 2


~~~PowerShell
    # Creates the code to broadast a message.
    {udp:// -Host [ipaddress]::broadcast -port 911 -Send "It's an emergency!"} | Use-PipeScript
~~~

##  Example 3


~~~PowerShell
    {send udp:// -Host [ipaddress]::broadcast -Port 911 "It's an emergency!"} | Use-PipeScript
~~~

##  Example 4


~~~PowerShell
    Use-PipeScript {
        watch udp://*:911
    
        send udp:// -Host [ipaddress]::broadcast -Port 911 "It's an emergency!"

        receive udp://*:911
    }
~~~


