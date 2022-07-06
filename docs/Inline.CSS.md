
Inline.CSS
----------
### Synopsis
CSS Inline PipeScript Transpiler.

---
### Description

Transpiles CSS with Inline PipeScript into CSS.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

This for Inline PipeScript to be used with operators, and still be valid CSS syntax. 

The CSS Inline Transpiler will consider the following syntax to be empty:

* ```(?<q>["'])\#[a-f0-9]{3}(\k<q>)```
* ```\#[a-f0-9]{6}```
* ```[\d\.](?>pt|px|em)```
* ```auto```

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    $StyleSheet = @'
MyClass {
text-color: "#000000" /*{
"'red'", "'green'","'blue'" | Get-Random
}*/;
}
'@
    [Save(".\StyleSheet.ps1.css")]$StyleSheet
}
```
.> .\StyleSheet.ps1.css
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
Inline.CSS [-CommandInfo] <Object> [<CommonParameters>]
```
---


