Signal.Nothing
--------------

### Synopsis
Outputs Nothing

---

### Description

Outputs nothing, unless debugging or verbose.  

If debugging, signals a PowerShell event with the .Arguments, .Input, and .Invocation

---

### Examples
> EXAMPLE 1

```PowerShell
1..1mb | Signal.Nothing
```
> EXAMPLE 2

```PowerShell
1..1kb | null
```

---

### Syntax
```PowerShell
Signal.Nothing [<CommonParameters>]
```
