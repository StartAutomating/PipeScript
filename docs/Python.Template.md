Python.Template
---------------

### Synopsis
Python Template Transpiler.

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

---

### Parameters
#### **CommandInfo**
The command information.  This will include the path to the file.

|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[CommandInfo]`|true    |named   |true (ByValue)|

#### **AsTemplateObject**
If set, will return the information required to dynamically apply this template to any text.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|true    |named   |false        |

#### **Parameter**
A dictionary of parameters.

|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |named   |false        |

#### **ArgumentList**
A list of arguments.

|Type          |Required|Position|PipelineInput|
|--------------|--------|--------|-------------|
|`[PSObject[]]`|false   |named   |false        |

---

### Syntax
```PowerShell
Python.Template -CommandInfo <CommandInfo> [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
```PowerShell
Python.Template -AsTemplateObject [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
