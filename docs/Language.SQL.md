Language.SQL
------------

### Synopsis
SQL PipeScript Language Definition.

---

### Description

Allows PipeScript to generate SQL.

PipeScript can be embedded in multiline or singleline format

In multiline format, PipeScript will be embedded within: `/*{...}*/`

In single line format

-- { or -- PipeScript{  begins a PipeScript block

-- } or -- }PipeScript  ends a PipeScript block

```SQL    
-- {

Uncommented lines between these two points will be ignored

--  # Commented lines will become PipeScript / PowerShell.
-- param($message = 'hello world')
-- "-- $message"
-- }
```

---

### Examples
> EXAMPLE 1

```PowerShell
Invoke-PipeScript {
    $SQLScript = '    
-- {
Uncommented lines between these two points will be ignored

--  # Commented lines will become PipeScript / PowerShell.
-- param($message = "hello world")
-- "-- $message"
-- }
'

    [OutputFile('.\HelloWorld.ps1.sql')]$SQLScript
}

Invoke-PipeScript .\HelloWorld.ps1.sql
```

---

### Syntax
```PowerShell
Language.SQL [<CommonParameters>]
```
