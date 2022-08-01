```https://api.github.com/repos/StartAutomating/PipeScript/issues``` is a valid command.

So is ```get https://api.github.com/repos/StartAutomating/PipeScript/issues```.
    
So is ```MyCustomProtocol:// -Parameter value```.

PipeScript supports transpiling protocols.

To be considered a protocol transpiler, a transpiler must:

1. Accept a ```[uri]``` from the pipeline
2. Have a parameter -CommandAST ```[Management.Automation.Language.CommandAST]``` 
3. Be valid, given a ```[Management.Automation.Language.CommandAST]```

~~~PipeScript{
    [PSCustomObject]@{
        Table = Get-Transpiler -TranspilerPath $pwd |
            Select-Object DisplayName, Synopsis, @{
                Name='Link'
                Expression = { $_.Name }
            }
    }}
~~~


~~~PipeScript{
    @(foreach ($transpiler in Get-Transpiler -TranspilerPath $pwd) {
        $examples = @($transpiler.Examples)
        if (-not $examples) { continue }
        for ($exampleNumber = 1; $exampleNumber -le $examples.Length; $exampleNumber++) {
            @("## $($transpiler.DisplayName) Example $($exampleNumber)", 
                [Environment]::Newline,
                "~~~PowerShell",                
                $examples[$exampleNumber - 1],                
                "~~~") -join [Environment]::Newline
        }        
    }) -join ([Environment]::Newline * 2)
}
~~~

