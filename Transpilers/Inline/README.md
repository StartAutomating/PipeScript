This directory contains Inline PipeScript transpilers for several languages.

PipeScript can currently be embedded in 35 languages or file types.

### Supported Languages


|Language                               |Synopsis                                |Pattern                         |
|---------------------------------------|----------------------------------------|--------------------------------|
|[ADA](Inline.ADA.psx.ps1)              |ADA PipeScript Transpiler.              |```\.ad[bs]$```                 |
|[ATOM](Inline.ATOM.psx.ps1)            |ATOM Inline PipeScript Transpiler.      |```\.atom$```                   |
|[Bash](Inline.Bash.psx.ps1)            |Bash PipeScript Transpiler.             |```\.sh$```                     |
|[Basic](Inline.Basic.psx.ps1)          |Basic PipeScript Transpiler.            |```\.(?>bas\\|vbs{0,1})$```     |
|[Batch](Inline.Batch.psx.ps1)          |Batch PipeScript Transpiler.            |```\.cmd$```                    |
|[Bicep](Inline.Bicep.psx.ps1)          |Bicep Inline PipeScript Transpiler.     |```\.bicep$```                  |
|[CPlusPlus](Inline.CPlusPlus.psx.ps1)  |C/C++ PipeScript Transpiler.            |```\.(?>c\\|cpp\\|h\\|swig)$``` |
|[CSharp](Inline.CSharp.psx.ps1)        |C# Inline PipeScript Transpiler.        |```\.cs$```                     |
|[CSS](Inline.CSS.psx.ps1)              |CSS Inline PipeScript Transpiler.       |```\.s{0,1}css$```              |
|[Go](Inline.Go.psx.ps1)                |Go PipeScript Transpiler.               |```\.go$```                     |
|[HCL](Inline.HCL.psx.ps1)              |HCL PipeScript Transpiler.              |```\.hcl$```                    |
|[HLSL](Inline.HLSL.psx.ps1)            |HLSL Inline PipeScript Transpiler.      |```\.hlsl$```                   |
|[HTML](Inline.HTML.psx.ps1)            |HTML PipeScript Transpiler.             |```\.htm{0,1}```                |
|[Java](Inline.Java.psx.ps1)            |Java Inline PipeScript Transpiler.      |```\.(?>java)$```               |
|[JavaScript](Inline.JavaScript.psx.ps1)|JavaScript Inline PipeScript Transpiler.|```\.js$```                     |
|[Json](Inline.Json.psx.ps1)            |JSON PipeScript Transpiler.             |```\.json$```                   |
|[Kotlin](Inline.Kotlin.psx.ps1)        |Kotlin Inline PipeScript Transpiler.    |```\.kt$```                     |
|[Markdown](Inline.Markdown.psx.ps1)    |Markdown File Transpiler.               |```\.(?>md\\|markdown)$```      |
|[ObjectiveC](Inline.ObjectiveC.psx.ps1)|Objective C PipeScript Transpiler.      |```\.(?>m\\|mm)$```             |
|[OpenSCAD](Inline.OpenSCAD.psx.ps1)    |OpenSCAD Inline PipeScript Transpiler.  |```\.scad$```                   |
|[Perl](Inline.Perl.psx.ps1)            |Perl Inline PipeScript Transpiler.      |```\.(?>pl\\|pod)$```           |
|[PHP](Inline.PHP.psx.ps1)              |PHP PipeScript Transpiler.              |```\.php$```                    |
|[PSD1](Inline.PSD1.psx.ps1)            |PSD1 Inline PipeScript Transpiler.      |```\.psd1$```                   |
|[Python](Inline.Python.psx.ps1)        |Python Inline PipeScript Transpiler.    |```\.py$```                     |
|[R](Inline.R.psx.ps1)                  |R PipeScript Transpiler.                |```\.r$```                      |
|[Razor](Inline.Razor.psx.ps1)          |Razor Inline PipeScript Transpiler.     |```\.(cshtml\\|razor)$```       |
|[RSS](Inline.RSS.psx.ps1)              |RSS Inline PipeScript Transpiler.       |```\.rss$```                    |
|[Ruby](Inline.Ruby.psx.ps1)            |Ruby Inline PipeScript Transpiler.      |```\.rb$```                     |
|[Rust](Inline.Rust.psx.ps1)            |Rust Inline PipeScript Transpiler.      |```\.rs$```                     |
|[SQL](Inline.SQL.psx.ps1)              |SQL PipeScript Transpiler.              |```\.sql$```                    |
|[TCL](Inline.TCL.psx.ps1)              |TCL/TK PipeScript Transpiler.           |```\.t(?>cl\\|k)$```            |
|[TOML](Inline.TOML.psx.ps1)            |TOML Inline PipeScript Transpiler.      |```\.toml$```                   |
|[TypeScript](Inline.TypeScript.psx.ps1)|TypeScript Inline PipeScript Transpiler.|```\.tsx{0,1}```                |
|[XML](Inline.XML.psx.ps1)              |XML Inline PipeScript Transpiler.       |```\.(?>xml\\|xaml\\|ps1xml)$```|
|[YAML](Inline.YAML.psx.ps1)            |Yaml File Transpiler.                   |```\.(?>yml\\|yaml)$```         |



### Contributing

If you would like to add support for writing a language with PipeScript, this is the place to put it.

Transpilers in this directory should:
* Be named ```Inline.NameOfLanguage.psx.ps1```.
* Accept ```[Management.Automation.CommandInfo]``` as a pipeline parameter.
* Use ```[ValidateScript({})]``` or ```[ValidatePattern()]``` to ensure that the correct file type is targeted.

Each file should handle one and only one language (better explicit than terse).

Transpilers should call ```.>PipeScript.Inline``` to simplify and standarize processing.




