This directory contains Template transpilers for several languages.

PipeScript can be used to generate ```.>{@(Get-Transpiler -TranspilerPath $pwd).Count}<.``` languages or file types.

### Supported Languages

~~~PipeScript{
    [PSCustomObject]@{
        Table = Get-Transpiler -TranspilerPath $pwd |
            Select-Object @{
                Name='Language'
                Expression= {
                    "[$($_.DisplayName -replace '\.Template$')]($($_.Name))"
                }
            }, @{
                Name='Synopsis'
                Expression= { $_.Synopsis -replace '[\s\r\n]+$' }
            }, @{
                Name='Pattern'
                Expression = { '```' + "$($_.ScriptBlock.Attributes.RegexPattern -replace '\|','\|')" + '```'}
            }
    }
}
~~~

### Contributing

If you would like to add support for writing a language with PipeScript, this is the place to put it.

Transpilers in this directory should:
* Be named ```Inline.NameOfLanguage.psx.ps1```.
* Accept ```[Management.Automation.CommandInfo]``` as a pipeline parameter.
* Use ```[ValidateScript({})]``` or ```[ValidatePattern()]``` to ensure that the correct file type is targeted.

Each file should handle one and only one language (better explicit than terse).

Transpilers should call ```.>PipeScript.Inline``` to simplify and standarize processing.



