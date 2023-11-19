System.Management.Automation.ScriptBlock.AllValid()
---------------------------------------------------

### Synopsis
Determines if any validation passes, given an object.

---

### Description

Determines if all of the `[ValidateScript]` or `[ValidatePattern]` attributes on a `[ScriptBlock]` pass, given one or more inputs.

Any input considered valid by all `[ValidateScript]` or `[ValidatePattern]` will be returned.

If there is no validation present, no objects will be returned.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    [ValidatePattern("a")]
    [ValidatePattern("c$")]
    param()
}.AllValid("c","b","a","abc")
```
> EXAMPLE 2

```PowerShell
{
    [ValidateScript({$_ % 2})]
    [ValidateScript({-not ($_ % 3)})]
    param()
}.AllValid(1..10)
```

---
