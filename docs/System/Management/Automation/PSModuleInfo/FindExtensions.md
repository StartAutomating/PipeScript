System.Management.Automation.PSModuleInfo.FindExtensions()
----------------------------------------------------------

### Synopsis
Finds extensions for a module

---

### Description

Finds extended commands for a module.

---

### Examples
> EXAMPLE 1

```PowerShell
(Get-Module PipeScript).FindExtensions((Get-Module PipeScript | Split-Path))
```

---
