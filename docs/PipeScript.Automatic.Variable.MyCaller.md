PipeScript.Automatic.Variable.MyCaller
--------------------------------------

### Synopsis
$MyCaller

---

### Description

$MyCaller (aka $CallStackPeek) contains the CallstackFrame that called this command.

---

### Examples
> EXAMPLE 1

```PowerShell
Invoke-PipeScript { $myCaller }
```

---

### Syntax
```PowerShell
PipeScript.Automatic.Variable.MyCaller [<CommonParameters>]
```
