
Inline.Json
-----------
### Synopsis
JSON PipeScript Transpiler.

---
### Description

Transpiles JSON with Inline PipeScript into JSON.

Multiline comments blocks like ```/*{}*/``` will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

* ```null```
* ```""```
* ```{}```
* ```[]```

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
Inline.Json [-CommandInfo] <Object> [<CommonParameters>]
```
---


