PipeScript.Automatic.Variable.MyParameters
------------------------------------------

### Synopsis
$MyParameters

---

### Description

$MyParameters contains a copy of $psBoundParameters.

This leaves you more free to change it.

---

### Examples
> EXAMPLE 1

```PowerShell
Invoke-PipeScript -ScriptBlock {
    $MyParameters
}
```

---

### Syntax
```PowerShell
PipeScript.Automatic.Variable.MyParameters [<CommonParameters>]
```
