System.Management.Automation.ScriptBlock.AllValidObject()
---------------------------------------------------------

### Synopsis
Determines if all validation matches, given an object.

---

### Description

Determines if all of the `[ValidateScript]` attributes on a `[ScriptBlock]` pass, given one or more inputs.

Any input considered valid by all `[ValidateScript]` will be returned.

If there is no validation present, no objects will be returned.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    [ValidateScript({$_ % 2})]
    [ValidateScript({-not ($_ % 3)})]
    param()
}.AllValidObject(1..10)
```
> EXAMPLE 2

---
