
BatchPowerShell
---------------
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
#### **Pwsh**

If set, will use PowerShell core (pwsh.exe).  If not, will use Windows PowerShell (powershell.exe)



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
### Syntax
```PowerShell
BatchPowerShell -ScriptInfo <ExternalScriptInfo> [-Pwsh] [<CommonParameters>]
```
```PowerShell
BatchPowerShell -ScriptBlock <ScriptBlock> [-Pwsh] [<CommonParameters>]
```
---



