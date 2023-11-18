System.Management.Automation.ValidateScriptAttribute.Validate()
---------------------------------------------------------------

### Synopsis
Validates an Object with a Script

---

### Description

Validates one or more objects against the .ScriptBlock of this attribute.

If the .ScriptBlock does not return "falsey" value (`$false, 0`), the validation will pass.

If there are no arguments passed, this's ErrorMessage starts with `$`, then the values produced by that expression will be validated.

---

### Examples
> EXAMPLE 1

```PowerShell
[ValidateScript]::new({$_ % 2}).Validate(1) # Should -Be $true
```
> EXAMPLE 2

```PowerShell
[ValidateScript]::new({$_ % 2}).Validate(0) # Should -Be $false
```

---
