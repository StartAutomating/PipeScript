System.Management.Automation.Language.ScriptRequirements.get_Script()
---------------------------------------------------------------------

### Synopsis
Gets the script that represents a requires statement

---

### Description

Gets the a PowerShell `[ScriptBlock]` that #requires the exact same list of script requirements.

This script method exists because it provides a way to check the requirements without actually running a full script.

---

### Examples
> EXAMPLE 1

```PowerShell
[ScriptBlock]::Create('#requires -Module PipeScript').Ast.ScriptRequirements.Script
```

---
