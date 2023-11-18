PipeScript.Automatic.Variable.IsPipedFrom
-----------------------------------------

### Synopsis
$IsPipedFrom

---

### Description

$IsPipedFrom determines if the pipeline continues after this command.

---

### Examples
> EXAMPLE 1

```PowerShell
$PipedFrom = & (Use-PipeScript { $IsPipedFrom })
$PipedFrom # Should -Be $False
```
> EXAMPLE 2

```PowerShell
& (Use-PipeScript { $IsPipedFrom }) | Foreach-Object { $_ } # Should -Be $true
```

---

### Syntax
```PowerShell
PipeScript.Automatic.Variable.IsPipedFrom [<CommonParameters>]
```
