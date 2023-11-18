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

|Type                  |Required|Position|PipelineInput |
|----------------------|--------|--------|--------------|
|`[ExternalScriptInfo]`|true    |named   |true (ByValue)|

#### **ScriptBlock**

|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[ScriptBlock]`|true    |named   |true (ByValue)|

#### **Pwsh**
If set, will use PowerShell core (pwsh.exe).  If not, will use Windows PowerShell (powershell.exe)

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

---

### Syntax
```PowerShell
BatchPowerShell -ScriptInfo <ExternalScriptInfo> [-Pwsh] [<CommonParameters>]
```
```PowerShell
BatchPowerShell -ScriptBlock <ScriptBlock> [-Pwsh] [<CommonParameters>]
```
