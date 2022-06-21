
Build-Pipescript
----------------
### Synopsis
Builds PipeScript Files

---
### Description

Builds PipeScript Files.

Any Source Generator Files Discovered by PipeScript will be run, which will convert them into source code.

---
### Parameters
#### **InputPath**

One or more input paths.  If no -InputPath is provided, will build all scripts beneath the current directory.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |1      |true (ByPropertyName)|
---
### Syntax
```PowerShell
Build-Pipescript [[-InputPath] <String[]>] [<CommonParameters>]
```
---


