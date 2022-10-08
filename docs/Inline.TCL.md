
Inline.TCL
----------
### Synopsis
TCL/TK PipeScript Transpiler.

---
### Description

Transpiles TCL or TK with Inline PipeScript into TCL or TK.

Because TCL Scripts only allow single-line comments, this is done using a pair of comment markers.

# { or # PipeScript{  begins a PipeScript block

# } or # }PipeScript  ends a PipeScript block

~~~tcl    
# {

Uncommented lines between these two points will be ignored

#  # Commented lines will become PipeScript / PowerShell.
# param($message = "hello world")
# "puts `"$message`""

# }
~~~

---
### Examples
#### EXAMPLE 1
```PowerShell
Invoke-PipeScript {
    $tclScript = '    
# {
```
Uncommented lines between these two points will be ignored

#  # Commented lines will become PipeScript / PowerShell.
# param($message = "hello world")
# "puts `"$message`""

# }
'

    [OutputFile('.\HelloWorld.ps1.tcl')]$tclScript
}

Invoke-PipeScript .\HelloWorld.ps1.tcl
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
Inline.TCL [-CommandInfo] <CommandInfo> [[-Parameter] <IDictionary>] [[-ArgumentList] <PSObject[]>] [<CommonParameters>]
```
---



