
Transpilers/Explicit.psx.ps1
----------------------------
### Synopsis
Makes Output from a PowerShell function Explicit.

---
### Description

Makes a PowerShell function explicitly output.

All statements will be assigned to $null, unless they explicitly use Write-Output or echo.

If Write-Output or echo is used, the command will be replaced for more effecient output.

---
### Parameters
#### **ScriptBlock**

|Type               |Requried|Postion|PipelineInput |
|-------------------|--------|-------|--------------|
|```[ScriptBlock]```|true    |1      |true (ByValue)|
---
### Outputs
System.Collections.IDictionary


---
### Syntax
```PowerShell
Transpilers/Explicit.psx.ps1 [-ScriptBlock] <ScriptBlock> [<CommonParameters>]
```
---


