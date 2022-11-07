```https://api.github.com/repos/StartAutomating/PipeScript/issues``` is a valid command.

So is ```get https://api.github.com/repos/StartAutomating/PipeScript/issues```.
    
So is ```MyCustomProtocol:// -Parameter value```.

PipeScript supports transpiling protocols.

To be considered a protocol transpiler, a transpiler must:

1. Accept a ```[uri]``` from the pipeline
2. Have a parameter -CommandAST ```[Management.Automation.Language.CommandAST]``` 
3. Be valid, given a ```[Management.Automation.Language.CommandAST]```


|DisplayName                                       |Synopsis                                           |
|--------------------------------------------------|---------------------------------------------------|
|[Http.Protocol](Http.Protocol.psx.ps1)            |[http protocol](Http.Protocol.psx.ps1)             |
|[JSONSchema.Protocol](JSONSchema.Protocol.psx.ps1)|[json schema protocol](JSONSchema.Protocol.psx.ps1)|
|[UDP.Protocol](UDP.Protocol.psx.ps1)              |[udp protocol](UDP.Protocol.psx.ps1)               |




## Http.Protocol Example 1


~~~PowerShell
    .> {
        https://api.github.com/repos/StartAutomating/PipeScript
    }
~~~

## Http.Protocol Example 2


~~~PowerShell
    {
        get https://api.github.com/repos/StartAutomating/PipeScript
    } | .>PipeScript
~~~

## Http.Protocol Example 3


~~~PowerShell
    Invoke-PipeScript {
        $GitHubApi = 'api.github.com'
        $UserName  = 'StartAutomating'
        https://$GitHubApi/users/$UserName
    }
~~~

## Http.Protocol Example 4


~~~PowerShell
    .> -ScriptBlock {
        https://$GitHubApi/users/$UserName -GitHubApi api.github.com -UserName StartAutomating
    }
~~~

## Http.Protocol Example 5


~~~PowerShell
    .> -ScriptBlock {
        https://$GitHubApi/users/$UserName -GitHubApi api.github.com -UserName StartAutomating
    }
~~~

## Http.Protocol Example 6


~~~PowerShell
    .> -ScriptBlock {
        @(foreach ($repo in https://api.github.com/users/StartAutomating/repos?per_page=100) {
            $repo | .Name .Stars { $_.stargazers_count }
        }) | Sort-Object Stars -Descending
    }
~~~

## Http.Protocol Example 7


~~~PowerShell
.> {
    http://text-processing.com/api/sentiment/ -Method POST -ContentType 'application/x-www-form-urlencoded' -Body "text=amazing!" |
        Select-Object -ExpandProperty Probability -Property Label
}
~~~

## JSONSchema.Protocol Example 1


~~~PowerShell
    jsonschema https://aka.ms/terminal-profiles-schema#/$defs/Profile
~~~

## UDP.Protocol Example 1


~~~PowerShell
    udp://127.0.0.1:8568  # Creates a UDP Client
~~~

## UDP.Protocol Example 2


~~~PowerShell
    udp:// -Host [ipaddress]::broadcast 911 -Send "It's an emergency!"
~~~

## UDP.Protocol Example 3


~~~PowerShell
    {send udp:// -Host [ipaddress]::broadcast -Port 911 "It's an emergency!"}.Transpile()
~~~

## UDP.Protocol Example 4


~~~PowerShell
    Invoke-PipeScript { receive udp://*:911 } 

    Invoke-PipeScript { send udp:// -Host [ipaddress]::broadcast -Port 911 "It's an emergency!" }

    Invoke-PipeScript { receive udp://*:911 -Keep }
~~~


