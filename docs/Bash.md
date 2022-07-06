
Bash
----
### Synopsis
Wraps PowerShell in a Bash Script

---
### Description

Wraps PowerShell in a Bash Script

---
### Parameters
#### **ScriptInfo**

|Type                      |Requried|Postion|PipelineInput |
|--------------------------|--------|-------|--------------|
|```[ExternalScriptInfo]```|true    |named  |true (ByValue)|
---
#### **ScriptBlock**

|Type               |Requried|Postion|PipelineInput |
|-------------------|--------|-------|--------------|
|```[ScriptBlock]```|true    |named  |true (ByValue)|
---
### Syntax
```PowerShell
Bash -ScriptInfo <ExternalScriptInfo> [<CommonParameters>]
```
```PowerShell
Bash -ScriptBlock <ScriptBlock> [<CommonParameters>]
```
---


