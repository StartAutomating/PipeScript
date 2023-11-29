PipeScript works with a number of Languages.

A Language is defined a function named Language.NameOfLanguage.

Languages may define an .Interpreter command or script.

If they do, that language can be interpretered within PipeScript.

## Languages with Interpreters

The following languages support interpreters.

~~~PipeScript{
"* $(
    @(@(
        foreach ($prop in $psLanguages.psobject.properties) {
            continue if -not $prop.IsInstance
            continue if -not $prop.Value.PSObject.Properties["Interpreter"]
            $prop.Name            
        }
    ) | Sort-Object) -join "$(
        [Environment]::newLine)* "
)"
}
~~~

Note: Interpreters may require commands to be installed.