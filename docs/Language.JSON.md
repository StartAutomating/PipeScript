Language.JSON
-------------

### Synopsis
JSON PipeScript Language Definition.

---

### Description

Allows PipeScript to generate JSON.

Multiline comments blocks like ```/*{}*/``` will be treated as blocks of PipeScript.

String output from these blocks will be embedded directly.  All other output will be converted to JSON.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

* ```null```
* ```""```
* ```{}```
* ```[]```

---

### Examples
> EXAMPLE 1

```PowerShell
Invoke-PipeScript {
    a.json template "{
    procs : null/*{Get-Process | Select Name, ID}*/
    }"
}
```

---

### Syntax
```PowerShell
Language.JSON [<CommonParameters>]
```
