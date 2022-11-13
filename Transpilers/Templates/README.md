This directory contains Inline PipeScript transpilers for several languages.

PipeScript can currently be embedded in 40 languages or file types.

### Supported Languages


|Language                                            |Synopsis                        |Pattern                         |
|----------------------------------------------------|--------------------------------|--------------------------------|
|[ADA.Template](ADA.Template.psx.ps1)                |ADA Template Transpiler.        |```\.ad[bs]$```                 |
|[ATOM.Template](ATOM.Template.psx.ps1)              |ATOM Template Transpiler.       |```\.atom$```                   |
|[Bash.Template](Bash.Template.psx.ps1)              |Bash Template Transpiler.       |```\.sh$```                     |
|[Basic.Template](Basic.Template.psx.ps1)            |Basic Template Transpiler.      |```\.(?>bas\\|vbs{0,1})$```     |
|[Batch.Template](Batch.Template.psx.ps1)            |Batch Template Transpiler.      |```\.cmd$```                    |
|[Bicep.Template](Bicep.Template.psx.ps1)            |Bicep Template Transpiler.      |```\.bicep$```                  |
|[CPlusPlus.Template](CPlusPlus.Template.psx.ps1)    |C/C++ Template Transpiler.      |```\.(?>c\\|cpp\\|h\\|swig)$``` |
|[CSharp.Template](CSharp.Template.psx.ps1)          |C# Template Transpiler.         |```\.cs$```                     |
|[CSS.Template](CSS.Template.psx.ps1)                |CSS Template Transpiler.        |```\.s{0,1}css$```              |
|[Go.Template](Go.Template.psx.ps1)                  |Go Template Transpiler.         |```\.go$```                     |
|[HAXE.Template](HAXE.Template.psx.ps1)              |Haxe Template Transpiler.       |```\.hx$```                     |
|[HCL.Template](HCL.Template.psx.ps1)                |HCL Template Transpiler.        |```\.hcl$```                    |
|[HLSL.Template](HLSL.Template.psx.ps1)              |HLSL Template Transpiler.       |```\.hlsl$```                   |
|[HTML.Template](HTML.Template.psx.ps1)              |HTML PipeScript Transpiler.     |```\.htm{0,1}```                |
|[Java.Template](Java.Template.psx.ps1)              |Java Template Transpiler.       |```\.(?>java)$```               |
|[JavaScript.Template](JavaScript.Template.psx.ps1)  |JavaScript Template Transpiler. |```\.js$```                     |
|[Json.Template](Json.Template.psx.ps1)              |JSON PipeScript Transpiler.     |```\.json$```                   |
|[Kotlin.Template](Kotlin.Template.psx.ps1)          |Kotlin Template Transpiler.     |```\.kt$```                     |
|[Latex.Template](Latex.Template.psx.ps1)            |Latex Template Transpiler.      |```\.(?>latex\\|tex)$```        |
|[LUA.Template](LUA.Template.psx.ps1)                |LUA Template Transpiler.        |```\.lua$```                    |
|[Markdown.Template](Markdown.Template.psx.ps1)      |Markdown Template Transpiler.   |```\.(?>md\\|markdown)$```      |
|[ObjectiveC.Template](ObjectiveC.Template.psx.ps1)  |Objective Template Transpiler.  |```\.(?>m\\|mm)$```             |
|[OpenSCAD.Template](OpenSCAD.Template.psx.ps1)      |OpenSCAD Template Transpiler.   |```\.scad$```                   |
|[Perl.Template](Perl.Template.psx.ps1)              |Perl Template Transpiler.       |```\.(?>pl\\|pod)$```           |
|[PHP.Template](PHP.Template.psx.ps1)                |PHP Template Transpiler.        |```\.php$```                    |
|[PSD1.Template](PSD1.Template.psx.ps1)              |PSD1 Template Transpiler.       |```\.psd1$```                   |
|[Python.Template](Python.Template.psx.ps1)          |Python Template Transpiler.     |```\.py$```                     |
|[R.Template](R.Template.psx.ps1)                    |R Template Transpiler.          |```\.r$```                      |
|[Racket.Template](Racket.Template.psx.ps1)          |Racket Template Transpiler.     |```\.rkt$```                    |
|[Razor.Template](Razor.Template.psx.ps1)            |Razor Template Transpiler.      |```\.(cshtml\\|razor)$```       |
|[RSS.Template](RSS.Template.psx.ps1)                |RSS Template Transpiler.        |```\.rss$```                    |
|[Ruby.Template](Ruby.Template.psx.ps1)              |Ruby Template Transpiler.       |```\.rb$```                     |
|[Rust.Template](Rust.Template.psx.ps1)              |Rust Template Transpiler.       |```\.rs$```                     |
|[SQL.Template](SQL.Template.psx.ps1)                |SQL Template Transpiler.        |```\.sql$```                    |
|[TCL.Template](TCL.Template.psx.ps1)                |TCL/TK Template Transpiler.     |```\.t(?>cl\\|k)$```            |
|[TOML.Template](TOML.Template.psx.ps1)              |TOML Template Transpiler.       |```\.toml$```                   |
|[TypeScript.Template](TypeScript.Template.psx.ps1)  |TypeScript Template Transpiler. |```\.tsx{0,1}```                |
|[WebAssembly.Template](WebAssembly.Template.psx.ps1)|WebAssembly Template Transpiler.|```\.wat$```                    |
|[XML.Template](XML.Template.psx.ps1)                |XML Template Transpiler.        |```\.(?>xml\\|xaml\\|ps1xml)$```|
|[YAML.Template](YAML.Template.psx.ps1)              |Yaml Template Transpiler.       |```\.(?>yml\\|yaml)$```         |



### Contributing

If you would like to add support for writing a language with PipeScript, this is the place to put it.

Transpilers in this directory should:
* Be named ```Inline.NameOfLanguage.psx.ps1```.
* Accept ```[Management.Automation.CommandInfo]``` as a pipeline parameter.
* Use ```[ValidateScript({})]``` or ```[ValidatePattern()]``` to ensure that the correct file type is targeted.

Each file should handle one and only one language (better explicit than terse).

Transpilers should call ```.>PipeScript.Inline``` to simplify and standarize processing.




