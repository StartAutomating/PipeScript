
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
    $OpenScadWithInlinePipeScript = @&#39;
Shape = &quot;cube&quot; /*{&#39;&quot;cube&quot;&#39;, &#39;&quot;sphere&quot;&#39;, &#39;&quot;circle&quot;&#39; | Get-Random}*/;
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



> **Type**: ```[CommandInfo]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByValue)



---
#### **Parameter**

A dictionary of parameters.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:false



---
#### **ArgumentList**

A list of arguments.



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:false



---
### Syntax
```PowerShell
Inline.OpenSCAD [-CommandInfo] &lt;CommandInfo&gt; [[-Parameter] &lt;IDictionary&gt;] [[-ArgumentList] &lt;PSObject[]&gt;] [&lt;CommonParameters&gt;]
```
---



