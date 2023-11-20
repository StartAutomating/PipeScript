Route.Uptime
------------

### Synopsis
Gets Uptime

---

### Description

A route for getting version uptime

---

### Examples
> EXAMPLE 1

```PowerShell
Get-PipeScript -PipeScriptType Route |
    Where-Object Name -Match 'Uptime' |
    Foreach-Object { & $_ }
```

---

### Syntax
```PowerShell
Route.Uptime [<CommonParameters>]
```
