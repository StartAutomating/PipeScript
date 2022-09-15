This directory contains Inline PipeScript transpilers for several languages.

PipeScript can currently be embedded in 34 languages or file types.

### Supported Languages


|Language                               |Synopsis                                                             |
|---------------------------------------|---------------------------------------------------------------------|
|[ADA](Inline.ADA.psx.ps1)              |[ADA PipeScript Transpiler.](Inline.ADA.psx.ps1)                     |
|[ATOM](Inline.ATOM.psx.ps1)            |[ATOM Inline PipeScript Transpiler.](Inline.ATOM.psx.ps1)            |
|[Bash](Inline.Bash.psx.ps1)            |[Bash PipeScript Transpiler.](Inline.Bash.psx.ps1)                   |
|[Basic](Inline.Basic.psx.ps1)          |[Basic PipeScript Transpiler.](Inline.Basic.psx.ps1)                 |
|[Batch](Inline.Batch.psx.ps1)          |[Batch PipeScript Transpiler.](Inline.Batch.psx.ps1)                 |
|[Bicep](Inline.Bicep.psx.ps1)          |[Bicep Inline PipeScript Transpiler.](Inline.Bicep.psx.ps1)          |
|[CPlusPlus](Inline.CPlusPlus.psx.ps1)  |[C/C++ PipeScript Transpiler.](Inline.CPlusPlus.psx.ps1)             |
|[CSharp](Inline.CSharp.psx.ps1)        |[C# Inline PipeScript Transpiler.](Inline.CSharp.psx.ps1)            |
|[CSS](Inline.CSS.psx.ps1)              |[CSS Inline PipeScript Transpiler.](Inline.CSS.psx.ps1)              |
|[Go](Inline.Go.psx.ps1)                |[Go PipeScript Transpiler.](Inline.Go.psx.ps1)                       |
|[HLSL](Inline.HLSL.psx.ps1)            |[HLSL Inline PipeScript Transpiler.](Inline.HLSL.psx.ps1)            |
|[HTML](Inline.HTML.psx.ps1)            |[HTML PipeScript Transpiler.](Inline.HTML.psx.ps1)                   |
|[Java](Inline.Java.psx.ps1)            |[Java Inline PipeScript Transpiler.](Inline.Java.psx.ps1)            |
|[JavaScript](Inline.JavaScript.psx.ps1)|[JavaScript Inline PipeScript Transpiler.](Inline.JavaScript.psx.ps1)|
|[Json](Inline.Json.psx.ps1)            |[JSON PipeScript Transpiler.](Inline.Json.psx.ps1)                   |
|[Kotlin](Inline.Kotlin.psx.ps1)        |[Kotlin Inline PipeScript Transpiler.](Inline.Kotlin.psx.ps1)        |
|[Markdown](Inline.Markdown.psx.ps1)    |[Markdown File Transpiler.](Inline.Markdown.psx.ps1)                 |
|[ObjectiveC](Inline.ObjectiveC.psx.ps1)|[Objective C PipeScript Transpiler.](Inline.ObjectiveC.psx.ps1)      |
|[OpenSCAD](Inline.OpenSCAD.psx.ps1)    |[OpenSCAD Inline PipeScript Transpiler.](Inline.OpenSCAD.psx.ps1)    |
|[Perl](Inline.Perl.psx.ps1)            |[Perl Inline PipeScript Transpiler.](Inline.Perl.psx.ps1)            |
|[PHP](Inline.PHP.psx.ps1)              |[PHP PipeScript Transpiler.](Inline.PHP.psx.ps1)                     |
|[PSD1](Inline.PSD1.psx.ps1)            |[PSD1 Inline PipeScript Transpiler.](Inline.PSD1.psx.ps1)            |
|[Python](Inline.Python.psx.ps1)        |[Python Inline PipeScript Transpiler.](Inline.Python.psx.ps1)        |
|[R](Inline.R.psx.ps1)                  |[R PipeScript Transpiler.](Inline.R.psx.ps1)                         |
|[Razor](Inline.Razor.psx.ps1)          |[Razor Inline PipeScript Transpiler.](Inline.Razor.psx.ps1)          |
|[RSS](Inline.RSS.psx.ps1)              |[RSS Inline PipeScript Transpiler.](Inline.RSS.psx.ps1)              |
|[Ruby](Inline.Ruby.psx.ps1)            |[Ruby Inline PipeScript Transpiler.](Inline.Ruby.psx.ps1)            |
|[Rust](Inline.Rust.psx.ps1)            |[Rust Inline PipeScript Transpiler.](Inline.Rust.psx.ps1)            |
|[SQL](Inline.SQL.psx.ps1)              |[SQL PipeScript Transpiler.](Inline.SQL.psx.ps1)                     |
|[TCL](Inline.TCL.psx.ps1)              |[TCL/TK PipeScript Transpiler.](Inline.TCL.psx.ps1)                  |
|[TOML](Inline.TOML.psx.ps1)            |[TOML Inline PipeScript Transpiler.](Inline.TOML.psx.ps1)            |
|[TypeScript](Inline.TypeScript.psx.ps1)|[TypeScript Inline PipeScript Transpiler.](Inline.TypeScript.psx.ps1)|
|[XML](Inline.XML.psx.ps1)              |[XML Inline PipeScript Transpiler.](Inline.XML.psx.ps1)              |
|[YAML](Inline.YAML.psx.ps1)            |[Yaml File Transpiler.](Inline.YAML.psx.ps1)                         |



### Contributing

If you would like to add support for writing a language with PipeScript, this is the place to put it.

Transpilers in this directory should:
* Be named ```Inline.NameOfLanguage.psx.ps1```.
* Accept ```[Management.Automation.CommandInfo]``` as a pipeline parameter.
* Use ```[ValidateScript({})]``` or ```[ValidatePattern()]``` to ensure that the correct file type is targeted.

Each file should handle one and only one language (better explicit than terse).

Transpilers should call ```.>PipeScript.Inline``` to simplify and standarize processing.




