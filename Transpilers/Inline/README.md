This directory contains Inline PipeScript transpilers for several languages.

PipeScript can currently be embedded in 15 languages.

Transpilers in this directory should be named ```Inline.NameOfLanguage.psx.ps1```.
Each file should handle one and only one language (better explicit than terse).

Transpilers should call ```.>PipeScript.Inline``` to simplify and standarize processing.


|Language                               |Synopsis                                                             |
|---------------------------------------|---------------------------------------------------------------------|
|[CPlusPlus](Inline.CPlusPlus.psx.ps1)  |[C/C++ PipeScript Transpiler.](Inline.CPlusPlus.psx.ps1)             |
|[CSharp](Inline.CSharp.psx.ps1)        |[C# Inline PipeScript Transpiler.](Inline.CSharp.psx.ps1)            |
|[CSS](Inline.CSS.psx.ps1)              |[CSS Inline PipeScript Transpiler.](Inline.CSS.psx.ps1)              |
|[Go](Inline.Go.psx.ps1)                |[Go PipeScript Transpiler.](Inline.Go.psx.ps1)                       |
|[HTML](Inline.HTML.psx.ps1)            |[HTML PipeScript Transpiler.](Inline.HTML.psx.ps1)                   |
|[Java](Inline.Java.psx.ps1)            |[Java Inline PipeScript Transpiler.](Inline.Java.psx.ps1)            |
|[JavaScript](Inline.JavaScript.psx.ps1)|[JavaScript Inline PipeScript Transpiler.](Inline.JavaScript.psx.ps1)|
|[Json](Inline.Json.psx.ps1)            |[JSON PipeScript Transpiler.](Inline.Json.psx.ps1)                   |
|[Markdown](Inline.Markdown.psx.ps1)    |[Markdown File Transpiler.](Inline.Markdown.psx.ps1)                 |
|[OpenSCAD](Inline.OpenSCAD.psx.ps1)    |[OpenSCAD Inline PipeScript Transpiler.](Inline.OpenSCAD.psx.ps1)    |
|[Ruby](Inline.Ruby.psx.ps1)            |[Ruby Inline PipeScript Transpiler.](Inline.Ruby.psx.ps1)            |
|[Rust](Inline.Rust.psx.ps1)            |[Rust Inline PipeScript Transpiler.](Inline.Rust.psx.ps1)            |
|[TOML](Inline.TOML.psx.ps1)            |[TOML Inline PipeScript Transpiler.](Inline.TOML.psx.ps1)            |
|[TypeScript](Inline.TypeScript.psx.ps1)|[TypeScript Inline PipeScript Transpiler.](Inline.TypeScript.psx.ps1)|
|[XML](Inline.XML.psx.ps1)              |[XML Inline PipeScript Transpiler.](Inline.XML.psx.ps1)              |



