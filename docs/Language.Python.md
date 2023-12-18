Language.Python
---------------

### Synopsis
Python Language Definition.

---

### Description

Allows PipeScript to generate Python.

Because Python does not support multiline comment blocks, PipeScript can be written inline inside of multiline string

PipeScript can be included in a Python string that starts and ends with ```{}```, for example ```"""{}"""```

---

### Examples
> EXAMPLE 1

```PowerShell
{
   $pythonContent = @'
"""{
$msg = "Hello World", "Hey There", "Howdy" | Get-Random
@"
print("$msg")
"@
}"""
'@
    [OutputFile('.\HelloWorld.ps1.py')]$PythonContent
}
.> .\HelloWorld.ps1.py
```
> EXAMPLE 2

```PowerShell
.\HelloWorld.py
Invoke-PipeScript .\HelloWorld.py # Should -Be 'Hello World'
```

---

### Syntax
```PowerShell
Language.Python [<CommonParameters>]
```
