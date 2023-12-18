System.Management.Automation.PSModuleInfo.File()
------------------------------------------------

### Synopsis
Gets a file in a module

---

### Description

Gets a file located within a module.

Hidden files are ignored.

---

### Examples
> EXAMPLE 1

```PowerShell
(Get-Module PipeScript).File(".\PipeScript.psd1")
```

---
