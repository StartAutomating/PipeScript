```https://api.github.com/repos/StartAutomating/PipeScript/issues``` is a valid command.

So is ```get https://api.github.com/repos/StartAutomating/PipeScript/issues```.
    
So is ```MyCustomProtocol:// -Parameter value```.

PipeScript supports transpiling protocols.

To be considered a protocol transpiler, a transpiler must:

1. Accept a ```[uri]``` from the pipeline
2. Have a parameter -CommandAST ```[Management.Automation.Language.CommandAST]``` 
3. Be valid, given a ```[Management.Automation.Language.CommandAST]```


|DisplayName                           |Synopsis                              |
|--------------------------------------|--------------------------------------|
|[Http.Protocol](Http.Protocol.psx.ps1)|[http protocol](Http.Protocol.psx.ps1)|




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


