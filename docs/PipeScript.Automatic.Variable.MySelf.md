PipeScript.Automatic.Variable.MySelf
------------------------------------

### Synopsis
$MySelf

---

### Description

$MySelf contains the currently executing ScriptBlock.

A Command can & $myself to use anonymous recursion.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    $mySelf
} | Use-PipeScript
```
By using $Myself, we can write an anonymously recursive fibonacci sequence.

```PowerShell
Invoke-PipeScript {
    param([int]$n = 1)
if ($n -lt 2) {
        $n
    } else {
        (& $myself ($n -1)) + (& $myself ($n -2))
    }
} -ArgumentList 10
```

---

### Syntax
```PowerShell
PipeScript.Automatic.Variable.MySelf [<CommonParameters>]
```
