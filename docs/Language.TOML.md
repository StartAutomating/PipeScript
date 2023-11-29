Language.TOML
-------------

### Synopsis
TOML PipeScript Language Definition.

---

### Description

Allows PipeScript to generate TOML.

Because TOML does not support comment blocks, PipeScript can be written inline inside of specialized Multiline string

PipeScript can be included in a TOML string that starts and ends with ```{}```, for example ```"""{}"""```

---

### Examples
> EXAMPLE 1

```PowerShell
{
    $tomlContent = @'
[seed]
RandomNumber = """{Get-Random}"""
'@
    [OutputFile('.\RandomExample.ps1.toml')]$tomlContent
}
.> .\RandomExample.ps1.toml
```

---

### Syntax
```PowerShell
Language.TOML [<CommonParameters>]
```
