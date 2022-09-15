This directory contains Inline PipeScript transpilers for several languages.

PipeScript can currently be embedded in 34 languages or file types.

### Supported Languages


|Language      |Synopsis                                |Pattern                         |
|--------------|----------------------------------------|--------------------------------|
|[ADA]()       |ADA PipeScript Transpiler.              |```\.ad[bs]$```                 |
|[ATOM]()      |ATOM Inline PipeScript Transpiler.      |```\.atom$```                   |
|[Bash]()      |Bash PipeScript Transpiler.             |```\.sh$```                     |
|[Basic]()     |Basic PipeScript Transpiler.            |```\.(?>bas\\|vbs{0,1})$```     |
|[Batch]()     |Batch PipeScript Transpiler.            |```\.cmd$```                    |
|[Bicep]()     |Bicep Inline PipeScript Transpiler.     |```\.bicep$```                  |
|[CPlusPlus]() |C/C++ PipeScript Transpiler.            |```\.(?>c\\|cpp\\|h\\|swig)$``` |
|[CSharp]()    |C# Inline PipeScript Transpiler.        |```\.cs$```                     |
|[CSS]()       |CSS Inline PipeScript Transpiler.       |```\.s{0,1}css$```              |
|[Go]()        |Go PipeScript Transpiler.               |```\.go$```                     |
|[HLSL]()      |HLSL Inline PipeScript Transpiler.      |```\.hlsl$```                   |
|[HTML]()      |HTML PipeScript Transpiler.             |```\.htm{0,1}```                |
|[Java]()      |Java Inline PipeScript Transpiler.      |```\.(?>java)$```               |
|[JavaScript]()|JavaScript Inline PipeScript Transpiler.|```\.js$```                     |
|[Json]()      |JSON PipeScript Transpiler.             |```\.json$```                   |
|[Kotlin]()    |Kotlin Inline PipeScript Transpiler.    |```\.kt$```                     |
|[Markdown]()  |Markdown File Transpiler.               |```\.(?>md\\|markdown)$```      |
|[ObjectiveC]()|Objective C PipeScript Transpiler.      |```\.(?>m\\|mm)$```             |
|[OpenSCAD]()  |OpenSCAD Inline PipeScript Transpiler.  |```\.scad$```                   |
|[Perl]()      |Perl Inline PipeScript Transpiler.      |```\.(?>pl\\|pod)$```           |
|[PHP]()       |PHP PipeScript Transpiler.              |```\.php$```                    |
|[PSD1]()      |PSD1 Inline PipeScript Transpiler.      |```\.psd1$```                   |
|[Python]()    |Python Inline PipeScript Transpiler.    |```\.py$```                     |
|[R]()         |R PipeScript Transpiler.                |```\.r$```                      |
|[Razor]()     |Razor Inline PipeScript Transpiler.     |```\.(cshtml\\|razor)$```       |
|[RSS]()       |RSS Inline PipeScript Transpiler.       |```\.rss$```                    |
|[Ruby]()      |Ruby Inline PipeScript Transpiler.      |```\.rb$```                     |
|[Rust]()      |Rust Inline PipeScript Transpiler.      |```\.rs$```                     |
|[SQL]()       |SQL PipeScript Transpiler.              |```\.sql$```                    |
|[TCL]()       |TCL/TK PipeScript Transpiler.           |```\.t(?>cl\\|k)$```            |
|[TOML]()      |TOML Inline PipeScript Transpiler.      |```\.toml$```                   |
|[TypeScript]()|TypeScript Inline PipeScript Transpiler.|```\.tsx{0,1}```                |
|[XML]()       |XML Inline PipeScript Transpiler.       |```\.(?>xml\\|xaml\\|ps1xml)$```|
|[YAML]()      |Yaml File Transpiler.                   |```\.(?>yml\\|yaml)$```         |



### Contributing

If you would like to add support for writing a language with PipeScript, this is the place to put it.

Transpilers in this directory should:
* Be named ```Inline.NameOfLanguage.psx.ps1```.
* Accept ```[Management.Automation.CommandInfo]``` as a pipeline parameter.
* Use ```[ValidateScript({})]``` or ```[ValidatePattern()]``` to ensure that the correct file type is targeted.

Each file should handle one and only one language (better explicit than terse).

Transpilers should call ```.>PipeScript.Inline``` to simplify and standarize processing.




