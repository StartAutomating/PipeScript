
Inline.OpenSCAD
---------------
### Synopsis
OpenSCAD Inline PipeScript Transpiler.

---
### Description

Transpiles OpenSCAD with Inline PipeScript into OpenSCAD.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

This for Inline PipeScript to be used with operators, and still be valid OpenSCAD syntax. 

The OpenSCAD Inline Transpiler will consider the following syntax to be empty:

* ```"[^"]+"```
* ```[\d\.]+```

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    $OpenScadWithInlinePipeScript = @'
Shape = "cube" /*{'"cube"', '"sphere"', '"circle"' | Get-Random}*/;
Size  = 1 /*{Get-Random -Min 1 -Max 100}*/ ;
```
if (Shape == "cube") {
cube(Size);
}
if (Shape == "sphere") {
sphere(Size);
}
if (Shape == "circle") {
circle(Size);
}
'@

    [OutputFile(".\RandomShapeAndSize.ps1.scad")]$OpenScadWithInlinePipeScript
}

.> .\RandomShapeAndSize.ps1.scad
---
### Parameters
#### **CommandInfo**

The command information.  This will include the path to the file.



|Type          |Requried|Postion|PipelineInput |
|--------------|--------|-------|--------------|
|```[Object]```|true    |1      |true (ByValue)|
---
### Syntax
```PowerShell
Inline.OpenSCAD [-CommandInfo] <Object> [<CommonParameters>]
```
---


