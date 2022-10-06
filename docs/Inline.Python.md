
Inline.Python
-------------
### Synopsis
Python Inline PipeScript Transpiler.

---
### Description

Transpiles Python with Inline PipeScript into Python.

Because Python does not support multiline comment blocks, PipeScript can be written inline inside of multiline string

PipeScript can be included in a Python string that starts and ends with ```{}```, for example ```"""{}"""```

---
### Examples
#### EXAMPLE 1
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
```
.> .\HelloWorld.ps1.py
---
### Parameters
#### **CommandInfo**

The command information.  This will include the path to the file.



> **Type**: ```[CommandInfo]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByValue)



---
#### **Parameter**

A dictionary of parameters.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:false



---
#### **ArgumentList**

A list of arguments.



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:false



---
### Syntax
```PowerShell
Inline.Python [-CommandInfo] <CommandInfo> [[-Parameter] <IDictionary>] [[-ArgumentList] <PSObject[]>] [<CommonParameters>]
```
---



