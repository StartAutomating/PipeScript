
Inline.PHP
----------
### Synopsis
PHP PipeScript Transpiler.

---
### Description

Transpiles PHP with Inline PipeScript into PHP.

Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.

JavaScript/CSS/PHP comment blocks like ```/*{}*/``` will also be treated as blocks of PipeScript.

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
Inline.PHP [-CommandInfo] <Object> [<CommonParameters>]
```
---


