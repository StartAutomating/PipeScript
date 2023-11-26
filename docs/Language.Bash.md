Language.Bash
-------------

### Synopsis
Bash Language Definition

---

### Description

Defines Bash within PipeScript.

This allows Rust to be templated.

Heredocs named PipeScript{} will be treated as blocks of PipeScript.

```bash
<<PipeScript{}

# This will be considered PipeScript / PowerShell, and will return the contents of a bash script.

PipeScript{}
```

---

### Examples
> EXAMPLE 1

```PowerShell
Invoke-PipeScript {
    $bashScript = '
    echo ''hello world''
<<PipeScript{}
        "echo ''$(''hi'',''yo'',''sup'' | Get-Random)''"
    PipeScript{}
'

    [OutputFile('.\HelloWorld.ps1.sh')]$bashScript
}

Invoke-PipeScript .\HelloWorld.ps1.sh
```

---

### Syntax
```PowerShell
Language.Bash [<CommonParameters>]
```
