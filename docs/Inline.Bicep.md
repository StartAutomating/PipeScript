
Inline.Bicep
------------
### Synopsis
Bicep Inline PipeScript Transpiler.

---
### Description

Transpiles Bicep with Inline PipeScript into Bicep.

Multiline comments blocks like ```/*{}*/``` will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

* ```''```
* ```{}```

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
Inline.Bicep [-CommandInfo] <Object> [<CommonParameters>]
```
---


