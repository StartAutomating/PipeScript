
Inline.PSD1
-----------
### Synopsis
PSD1 Inline PipeScript Transpiler.

---
### Description

Transpiles PSD1 with Inline PipeScript into PSD1.

Multiline comments blocks enclosed with {} will be treated as Blocks of PipeScript.

Multiline comments can be preceeded or followed by single-quoted strings, which will be ignored.

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
Inline.PSD1 [-CommandInfo] <Object> [<CommonParameters>]
```
---


