System.Management.Automation.ScriptBlock.AllValidMatch()
--------------------------------------------------------

### Synopsis
Determines if all validation matches, given an object.

---

### Description

Determines if all of the `[ValidatePattern]` attributes on a `[ScriptBlock]` pass, given one or more inputs.

Any input considered valid by all `[ValidatePattern]` will be returned.

If there is no validation present, no objects will be returned.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    [ValidatePattern("a")]
    [ValidatePattern("c$")]
    param()
}.AllValidMatches("c","b","a","abc")
```
> EXAMPLE 2

```PowerShell
{
    [ValidatePattern("a")]
    [ValidatePattern("c$")]
    param()
}.AllValidMatch("c","b","a","abc")
```

---
