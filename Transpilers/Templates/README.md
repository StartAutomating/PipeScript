This directory contains Template transpilers for several languages.

PipeScript can be used to generate 44 languages or file types.

### Supported Languages


|Language                                   |Synopsis                        |Pattern                         |
|-------------------------------------------|--------------------------------|--------------------------------|
|[Bash](Bash.Template.psx.ps1)              |Bash Template Transpiler.       |```\.sh$```                     |
|[Basic](Basic.Template.psx.ps1)            |Basic Template Transpiler.      |```\.(?>bas\\|vbs{0,1})$```     |
|[Batch](Batch.Template.psx.ps1)            |Batch Template Transpiler.      |```\.cmd$```                    |
|[Bicep](Bicep.Template.psx.ps1)            |Bicep Template Transpiler.      |```\.bicep$```                  |
|[CPlusPlus](CPlusPlus.Template.psx.ps1)    |C/C++ Template Transpiler.      |```\.(?>c\\|cpp\\|h\\|swig)$``` |
|[CSharp](CSharp.Template.psx.ps1)          |C# Template Transpiler.         |```\.cs$```                     |
|[CSS](CSS.Template.psx.ps1)                |CSS Template Transpiler.        |```\.s{0,1}css$```              |
|[Dart](Dart.Template.psx.ps1)              |Dart Template Transpiler.       |```\.(?>dart)$```               |
|[Eiffel](Eiffel.Template.psx.ps1)          |Eiffel Template Transpiler.     |```\.e$```                      |
|[Go](Go.Template.psx.ps1)                  |Go Template Transpiler.         |```\.go$```                     |
|[HAXE](HAXE.Template.psx.ps1)              |Haxe Template Transpiler.       |```\.hx$```                     |
|[HCL](HCL.Template.psx.ps1)                |HCL Template Transpiler.        |```\.hcl$```                    |
|[HLSL](HLSL.Template.psx.ps1)              |HLSL Template Transpiler.       |```\.hlsl$```                   |
|[HTML](HTML.Template.psx.ps1)              |HTML PipeScript Transpiler.     |```\.htm{0,1}```                |
|[Java](Java.Template.psx.ps1)              |Java Template Transpiler.       |```\.(?>java)$```               |
|[JavaScript](JavaScript.Template.psx.ps1)  |JavaScript Template Transpiler. |```\.js$```                     |
|[Json](Json.Template.psx.ps1)              |JSON PipeScript Transpiler.     |```\.json$```                   |
|[Kotlin](Kotlin.Template.psx.ps1)          |Kotlin Template Transpiler.     |```\.kt$```                     |
|[Kusto](Kusto.Template.psx.ps1)            |Kusto Template Transpiler.      |```\.kql$```                    |
|[Latex](Latex.Template.psx.ps1)            |Latex Template Transpiler.      |```\.(?>latex\\|tex)$```        |
|[LUA](LUA.Template.psx.ps1)                |LUA Template Transpiler.        |```\.lua$```                    |
|[Markdown](Markdown.Template.psx.ps1)      |Markdown Template Transpiler.   |```\.(?>md\\|markdown\\|txt)$```|
|[ObjectiveC](ObjectiveC.Template.psx.ps1)  |Objective Template Transpiler.  |```\.(?>m\\|mm)$```             |
|[OpenSCAD](OpenSCAD.Template.psx.ps1)      |OpenSCAD Template Transpiler.   |```\.scad$```                   |
|[Perl](Perl.Template.psx.ps1)              |Perl Template Transpiler.       |```\.(?>pl\\|pod)$```           |
|[PHP](PHP.Template.psx.ps1)                |PHP Template Transpiler.        |```\.php$```                    |
|[PS1XML](PS1XML.Template.psx.ps1)          |PS1XML Template Transpiler.     |```\.ps1xml$```                 |
|[PSD1](PSD1.Template.psx.ps1)              |PSD1 Template Transpiler.       |```\.psd1$```                   |
|[Python](Python.Template.psx.ps1)          |Python Template Transpiler.     |```\.py$```                     |
|[R](R.Template.psx.ps1)                    |R Template Transpiler.          |```\.r$```                      |
|[Racket](Racket.Template.psx.ps1)          |Racket Template Transpiler.     |```\.rkt$```                    |
|[Razor](Razor.Template.psx.ps1)            |Razor Template Transpiler.      |```\.(cshtml\\|razor)$```       |
|[RSS](RSS.Template.psx.ps1)                |RSS Template Transpiler.        |```\.rss$```                    |
|[Ruby](Ruby.Template.psx.ps1)              |Ruby Template Transpiler.       |```\.rb$```                     |
|[Scala](Scala.Template.psx.ps1)            |Scala Template Transpiler.      |```\.(?>scala\\|sc)$```         |
|[SQL](SQL.Template.psx.ps1)                |SQL Template Transpiler.        |```\.sql$```                    |
|[SVG](SVG.template.psx.ps1)                |SVG Template Transpiler.        |```\.svg$```                    |
|[TCL](TCL.Template.psx.ps1)                |TCL/TK Template Transpiler.     |```\.t(?>cl\\|k)$```            |
|[TOML](TOML.Template.psx.ps1)              |TOML Template Transpiler.       |```\.toml$```                   |
|[TypeScript](TypeScript.Template.psx.ps1)  |TypeScript Template Transpiler. |```\.tsx{0,1}```                |
|[WebAssembly](WebAssembly.Template.psx.ps1)|WebAssembly Template Transpiler.|```\.wat$```                    |
|[XAML](XAML.Template.psx.ps1)              |XAML Template Transpiler.       |```\.xaml$```                   |
|[XML](XML.Template.psx.ps1)                |XML Template Transpiler.        |```\.xml$```                    |
|[YAML](YAML.Template.psx.ps1)              |Yaml Template Transpiler.       |```\.(?>yml\\|yaml)$```         |



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




