Automatic Variables Commands allow the definition of an automatic variable.

Instead of these commands being run directly, they will be embedded inline.

Automatic Variables are embedded in post processing by [PostProcess.InitializeAutomaticVariable](docs/PostProcess.InitializeAutomaticVariable.md).

~~~PipeScript{
    # Then, let's create a lookup table by the name of the automatic variable
    
    $automaticVariableCommands = Get-PipeScript -PipesScriptType AutomaticVariable

    [PSCustomObject]@{
        Table = 
            $automaticVariableCommands |
            select -Unique @{
                Name='VariableName'
                Expression={
                    "[$($_.VariableName)]($("/docs/$($_.Name).md"))"
                }            
            }, Description |
            Sort-Object VariableName
    }
}
~~~
