## Protocols in PipeScript

```https://api.github.com/repos/StartAutomating/PipeScript/issues``` is a valid command.

So is ```get https://api.github.com/repos/StartAutomating/PipeScript/issues```.
    
So is ```MyCustomProtocol:// -Parameter value```.

PipeScript supports transpiling protocols.

Any command where :// appears in it's first two elements will be considered a potential protocol.

~~~PipeScript{    
    [PSCustomObject]@{
        Table = Get-PipeScript -PipeScriptType Protocol |
            Select-Object Name, Synopsis, @{
                Name='Link'
                Expression = { "/docs/$($_.Name).md" }
            }
    }
}
~~~

## Protocol Examples

All of the current protocol examples are listed below:

~~~PipeScript{
    @(foreach ($protocolCommand in Get-PipeScript -PipeScriptType Protocol) {
        $examples = @($protocolCommand.Examples)
        if (-not $examples) { continue }
        for ($exampleNumber = 1; $exampleNumber -le $examples.Length; $exampleNumber++) {
            @("## $($protocolCommand.DisplayName) Example $($exampleNumber)", 
                [Environment]::Newline,
                "~~~PowerShell",                
                $examples[$exampleNumber - 1],                
                "~~~") -join [Environment]::Newline
        }        
    }) -join ([Environment]::Newline * 2)
}
~~~

