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

> **Type**: ```[ExternalScriptInfo]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
#### **ScriptBlock**

> **Type**: ```[ScriptBlock]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
#### **WindowsPowerShell**

If set, will use Windows PowerShell core (powershell.exe).  If not, will use PowerShell Core (pwsh.exe)



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
Batch -ScriptInfo <ExternalScriptInfo> [-WindowsPowerShell] [<CommonParameters>]
```
```PowerShell
Batch -ScriptBlock <ScriptBlock> [-WindowsPowerShell] [<CommonParameters>]
```
---

