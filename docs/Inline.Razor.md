
Inline.Razor
------------
### Synopsis
Razor Inline PipeScript Transpiler.

---
### Description

Transpiles Razor with Inline PipeScript into Razor.

Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.

JavaScript/CSS comment blocks like ```/*{}*/``` will also be treated as blocks of PipeScript.

Razor comment blocks like ```@*{}*@``` will also be treated as blocks of PipeScript.

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
Inline.Razor [-CommandInfo] <CommandInfo> [[-Parameter] <IDictionary>] [[-ArgumentList] <PSObject[]>] [<CommonParameters>]
```
---



