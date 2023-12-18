System.Management.Automation.ScriptBlock.AnyValid()
---------------------------------------------------

### Synopsis
Determines if any validation passes, given an object.

---

### Description

Determines if any of the `[ValidateScript]` or `[ValidatePattern]` attributes on a `[ScriptBlock]` passes, given an input.

Any input considered valid by a `[ValidateScript]` or `[ValidatePattern]` will be returned.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    [ValidatePattern("a")]
    [ValidatePattern("b")]
    param()
}.AnyValid("c","b","a")
```
> EXAMPLE 2

```PowerShell
{
    [ValidateScript({$_ % 2})]
    [ValidateScript({-not ($_ % 3)})]
    param()
}.AnyValid(1..10)
```

---
