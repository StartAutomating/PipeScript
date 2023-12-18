System.Management.Automation.ScriptBlock.AnyValidObject()
---------------------------------------------------------

### Synopsis
Determines if any validation passes, given an object.

---

### Description

Determines if any of the `[ValidateScript]` attributes on a `[ScriptBlock]` passes, given an input.

Any input considered valid by a `[ValidateScript]` will be returned.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    [ValidateScript({$_ -like "a*" })]        
    param()
}.AnyValidObject("a")
```

---
