PipeScript can work with any technology.

Any command with any of these keywords in it's name will be considered a Technology:

* Tech(s)
* Technology
* Engine(s)
* Framework(s)
* Platform(s)

All languages are also considered technology.

PipeScript presently ships with `|{(Get-PipeScript -PipeScriptType Technology).Length}|` technologies:

~~~PipeScript{
"* $(
    @(@(
        foreach ($prop in $psTechnology.psobject.properties) {
            if ($prop.IsInstance) {
                $prop.Name
            }
        }
    ) | Sort-Object) -join "$(
        [Environment]::newLine)* "
)"
}
~~~
