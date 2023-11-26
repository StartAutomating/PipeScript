Language.OpenSCAD
-----------------

### Synopsis
OpenSCAD Language Definition.

---

### Description

Allows PipeScript to generate OpenSCAD.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

The OpenSCAD Inline Transpiler will consider the following syntax to be empty:

* ```"[^"]+"```
* ```[\d\.]+```

---

### Examples
> EXAMPLE 1

```PowerShell
{
    $OpenScadWithInlinePipeScript = @'
Shape = "cube" /*{'"cube"', '"sphere"', '"circle"' | Get-Random}*/;
Size  = 1 /*{Get-Random -Min 1 -Max 100}*/ ;
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
```

---

### Syntax
```PowerShell
Language.OpenSCAD [<CommonParameters>]
```
