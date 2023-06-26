```https://api.github.com/repos/StartAutomating/PipeScript/issues``` is a valid command.

So is ```get https://api.github.com/repos/StartAutomating/PipeScript/issues```.
    
So is ```MyCustomProtocol:// -Parameter value```.

PipeScript supports transpiling protocols.

To be considered a protocol transpiler, a transpiler must:

1. Accept a ```[uri]``` from the pipeline
2. Have a parameter -CommandAST ```[Management.Automation.Language.CommandAST]``` 
3. Be valid, given a ```[Management.Automation.Language.CommandAST]```


|Table|
|-----|
||







