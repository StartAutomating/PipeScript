Language.get_HasPowerShellInterpreter()
---------------------------------------

### Synopsis
Determines if a language has a PowerShell interpreter

---

### Description

Determines if a language's interpreter is PowerShell or an external application.

---

### Notes
Returns $true is the interpreter is a `[ScriptBlock]`, `[FunctionInfo]`, or `[CmdletInfo]`,
or an `[AliasInfo]` that does not point to an application.  Otherwise, returns $false.

---
