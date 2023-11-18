System.Management.Automation.ValidatePatternAttribute.Validate()
----------------------------------------------------------------

### Synopsis
Validates an Object against a Pattern

---

### Description

Validates one or more objects against the .RegexPattern of this attribute.

---

### Examples
> EXAMPLE 1

```PowerShell
[ValidatePattern]::new("a").Validate("a") # Should -Be $true
```
> EXAMPLE 2

```PowerShell
[ValidatePattern]::new("a").Validate("b") # Should -Be $false
```

---
