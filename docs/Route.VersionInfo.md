Route.VersionInfo
-----------------

### Synopsis
Gets Version Information

---

### Description

A route for getting version information

---

### Examples
> EXAMPLE 1

```PowerShell
Get-PipeScript -PipeScriptType Route |
    Where-Object Name -Match 'Route\.VersionInfo' |
    Select-Object -First 1 |
    Foreach-Object { & $_ }
```

---

### Syntax
```PowerShell
Route.VersionInfo [<CommonParameters>]
```
