Language.ADA
------------

### Synopsis
ADA Language Definition

---

### Description

Defines ADA within PipeScript.

This allows ADA to be templated.

Because ADA Scripts only allow single-line comments, this is done using a pair of comment markers.

-- { or -- PipeScript{  begins a PipeScript block

-- } or -- }PipeScript  ends a PipeScript block

---

### Examples
> EXAMPLE 1

```PowerShell
Invoke-PipeScript {
    $AdaScript = '    
with Ada.Text_IO;
procedure Hello_World is
begin
    -- {

    Uncommented lines between these two points will be ignored

    --  # Commented lines will become PipeScript / PowerShell.
    -- param($message = "hello world")        
    -- "Ada.Text_IO.Put_Line (`"$message`");"
    -- }
end Hello_World;    
'

    [OutputFile('.\HelloWorld.ps1.adb')]$AdaScript
}

Invoke-PipeScript .\HelloWorld.ps1.adb
```

---

### Syntax
```PowerShell
Language.ADA [<CommonParameters>]
```
