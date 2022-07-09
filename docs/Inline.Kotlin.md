
Inline.Kotlin
-------------
### Synopsis
Kotlin Inline PipeScript Transpiler.

---
### Description

Transpiles Kotlin with Inline PipeScript into Kotlin.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

This for Inline PipeScript to be used with operators, and still be valid Kotlin syntax. 

The Kotlin Inline PipeScript Transpiler will consider the following syntax to be empty:

* ```null```
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
Inline.Kotlin [-CommandInfo] <Object> [<CommonParameters>]
```
---


