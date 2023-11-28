PipeScript works with a number of Languages.

A Language is defined a function named Language.NameOfLanguage.

PipeScript presently ships with `|{(Get-PipeScript -PipeScriptType Language).Length}|` languages:

~~~PipeScript{
"* $(
    @(
        foreach ($prop in $psLanguages.psobject.properties) {
            if ($prop.IsInstance) {
                $prop.Name
            }
        }
    ) -join "$(
        [Environment]::newLine)* "
)"
}
~~~
