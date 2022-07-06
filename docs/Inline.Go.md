
Inline.Go
---------
### Synopsis
Go PipeScript Transpiler.

---
### Description

Transpiles Go with Inline PipeScript into Go.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

This for Inline PipeScript to be used with operators, and still be valid Go syntax. 

The Go Transpiler will consider the following syntax to be empty:

* ```nil```
* ```""```
* ```''```

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
Inline.Go [-CommandInfo] <Object> [<CommonParameters>]
```
---


