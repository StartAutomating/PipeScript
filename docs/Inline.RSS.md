
Inline.RSS
----------
### Synopsis
RSS Inline PipeScript Transpiler.

---
### Description

Transpiles RSS with Inline PipeScript into RSS.

Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.

---
### Parameters
#### **CommandInfo**

The command information.  This will include the path to the file.



|Type          |Requried|Postion|PipelineInput |
|--------------|--------|-------|--------------|
|```[Object]```|true    |1      |true (ByValue)|
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
Inline.RSS [-CommandInfo] <Object> [[-Parameter] <IDictionary>] [[-ArgumentList] <PSObject[]>] [<CommonParameters>]
```
---


