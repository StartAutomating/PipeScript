This directory contains Template transpilers for several languages.

PipeScript can be used to generate 5 languages or file types.

### Supported Languages


|Language                                   |Synopsis                        |Pattern                |
|-------------------------------------------|--------------------------------|-----------------------|
|[Python](Python.Template.psx.ps1)          |Python Template Transpiler.     |```\.py$```            |
|[WebAssembly](WebAssembly.Template.psx.ps1)|WebAssembly Template Transpiler.|```\.wat$```           |
|[XAML](XAML.Template.psx.ps1)              |XAML Template Transpiler.       |```\.xaml$```          |
|[XML](XML.Template.psx.ps1)                |XML Template Transpiler.        |```\.xml$```           |
|[YAML](YAML.Template.psx.ps1)              |Yaml Template Transpiler.       |```\.(?>yml\\|yaml)$```|



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




