```https://api.github.com/repos/StartAutomating/PipeScript/issues``` is a valid command.

So is ```get https://api.github.com/repos/StartAutomating/PipeScript/issues```.
    
So is ```MyCustomProtocol:// -Parameter value```.

PipeScript supports transpiling protocols.

To be considered a protocol transpiler, a transpiler must:

1. Accept a ```[uri]``` from the pipeline
2. Have a parameter -CommandAST ```[Management.Automation.Language.CommandAST]``` 
3. Be valid, given a ```[Management.Automation.Language.CommandAST]```


|DisplayName                         |Synopsis                            |
|------------------------------------|------------------------------------|
|[UDP.Protocol](UDP.Protocol.psx.ps1)|[udp protocol](UDP.Protocol.psx.ps1)|




## UDP.Protocol Example 1


~~~PowerShell
    udp://127.0.0.1:8568  # Creates a UDP Client
~~~

## UDP.Protocol Example 2


~~~PowerShell
    udp:// -Host [ipaddress]::broadcast -port 911 -Send "It's an emergency!"
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


