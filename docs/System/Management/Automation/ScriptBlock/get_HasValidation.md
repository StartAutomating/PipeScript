System.Management.Automation.ScriptBlock.get_HasValidation()
------------------------------------------------------------

### Synopsis
Determines if a ScriptBlock has validation

---

### Description

Determines if a ScriptBlock has either a `[ValidatePattern]` or a `[ValidateScript]` attribute defined.

---

### Examples
> EXAMPLE 1

```PowerShell
{}.HasValidation
```
> EXAMPLE 2

```PowerShell
{[ValidateScript({$true})]param()}.HasValidation
```

---
