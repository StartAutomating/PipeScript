System.Management.Automation.PSModuleInfo.FindMetadata()
--------------------------------------------------------

### Synopsis
Finds metadata for a module

---

### Description

Finds metadata for a module.

This searches the `.PrivateData` and `.PrivateData.PSData` for keywords, and returns the values.

---

### Examples
> EXAMPLE 1

```PowerShell
(Get-Module PipeScript).FindExtensions((Get-Module PipeScript | Split-Path))
```

---

### Notes
If the value points to a `[Hashtable]`, it will return a `[PSCustomObject]` with the keys sorted.
If the value points to a file, it will attempt to load it or return the file object.
If the value is a string, it will return the string as a `[PSObject]`.

---
