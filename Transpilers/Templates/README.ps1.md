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
* Be named `NameOfLanguage.Template.psx.ps1`.
* Accept `[Management.Automation.CommandInfo]` as a pipeline parameter, in it's own parameter set
* Accept `[switch]$AsTemplateObject` as a mandatory parameter in it's own parameter set.
* Use `[ValidatePattern()]` to ensure that the correct file type is targeted.

The template transpiler will then create a set of parameters to PipeScript.Template.

If $AsTemplateObject is passed, these parameters should be returned directly.
Otherwise, the template transpiler should call ```.>PipeScript.Template```.



