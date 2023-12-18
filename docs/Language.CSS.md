Language.CSS
------------

### Synopsis
CSS Language Definition.

---

### Description

Allows PipeScript to generate CSS.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

The CSS Inline Transpiler will consider the following syntax to be empty:

* ```(?<q>["'])\#[a-f0-9]{3}(\k<q>)```
* ```\#[a-f0-9]{6}```
* ```[\d\.](?>pt|px|em)```
* ```auto```

---

### Examples
> EXAMPLE 1

```PowerShell
{
    $StyleSheet = '
MyClass {
text-color: "#000000" /*{
"''red''", "''green''","''blue''" | Get-Random
}*/;
}
'
    [Save(".\StyleSheet.ps1.css")]$StyleSheet
}
.> .\StyleSheet.ps1.css
```

---

### Syntax
```PowerShell
Language.CSS [<CommonParameters>]
```
