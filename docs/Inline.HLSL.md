
Inline.HLSL
-----------
### Synopsis
HLSL Inline PipeScript Transpiler.

---
### Description

Transpiles HLSL with Inline PipeScript into HLSL.    

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

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
Inline.HLSL [-CommandInfo] <Object> [[-Parameter] <IDictionary>] [[-ArgumentList] <PSObject[]>] [<CommonParameters>]
```
---


