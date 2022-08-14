
Inline.JavaScript
-----------------
### Synopsis
JavaScript Inline PipeScript Transpiler.

---
### Description

Transpiles JavaScript with Inline PipeScript into JavaScript.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

This is so that Inline PipeScript can be used with operators, and still be valid JavaScript syntax.

The JavaScript Inline Transpiler will consider the following syntax to be empty:

* ```undefined```
* ```null```
* ```""```
* ```''```

---
### Parameters
#### **CommandInfo**

The command information.  This will include the path to the file.



|Type               |Requried|Postion|PipelineInput |
|-------------------|--------|-------|--------------|
|```[CommandInfo]```|true    |1      |true (ByValue)|
---
#### **Parameter**

A dictionary of parameters.



|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[IDictionary]```|false   |2      |false        |
---
#### **ArgumentList**

A list of arguments.



|Type              |Requried|Postion|PipelineInput|
|------------------|--------|-------|-------------|
|```[PSObject[]]```|false   |3      |false        |
---
### Syntax
```PowerShell
Inline.JavaScript [-CommandInfo] <CommandInfo> [[-Parameter] <IDictionary>] [[-ArgumentList] <PSObject[]>] [<CommonParameters>]
```
---


