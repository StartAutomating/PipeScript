~~~PipeScript{
    # Then, let's create a lookup table by the name of the automatic variable
    
    $automaticVariableCommands = 
        all @((Get-Module PipeScript).ExportedCommands.Values) where { $_ -match '(?>Automatic|Magic)\p{P}Variable\p{P}' } are an Automatic.Variable.Command

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
