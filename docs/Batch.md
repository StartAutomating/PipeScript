
Batch
-----
### Synopsis
Wraps PowerShell in a Windows Batch Script

---
### Description

Wraps PowerShell in a Windows Batch Script

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
#### **WindowsPowerShell**

If set, will use Windows PowerShell core (powershell.exe).  If not, will use PowerShell Core (pwsh.exe)



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
### Syntax
```PowerShell
Batch -ScriptInfo <ExternalScriptInfo> [-WindowsPowerShell] [<CommonParameters>]
```
```PowerShell
Batch -ScriptBlock <ScriptBlock> [-WindowsPowerShell] [<CommonParameters>]
```
---


