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
.\HelloWorld.py
Invoke-PipeScript .\HelloWorld.py
```
> EXAMPLE 2

```PowerShell
Template.HelloWorld.py -Message "Hi" | Set-Content ".\Hi.py"
Invoke-PipeScript .\Hi.py
```

---

### Syntax
```PowerShell
Language.Python [<CommonParameters>]
```
