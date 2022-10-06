
Inline.Basic
------------
### Synopsis
Basic PipeScript Transpiler.

---
### Description

Transpiles Basic, Visual Basic, and Visual Basic Scripts with Inline PipeScript.

Because Basic only allow single-line comments, this is done using a pair of comment markers.

A single line comment, followed by a { (or PipeScript { ) begins a block of pipescript.

A single line comment, followed by a } (or PipeScript } ) ends a block of pipescript.

Only commented lines within this block will be interpreted as PipeScript.
        
```VBScript    
rem {

Uncommented lines between these two points will be ignored

rem # Commented lines will become PipeScript / PowerShell.
rem param($message = "hello world")
rem "CreateObject(`"WScript.Shell`").Popup(`"$message`")" 
rem }
```

---
### Examples
#### EXAMPLE 1
```PowerShell
Invoke-PipeScript {
    $VBScript = '    
rem {
```
Uncommented lines between these two points will be ignored

rem # Commented lines will become PipeScript / PowerShell.
rem param($message = "hello world")
rem "CreateObject(`"WScript.Shell`").Popup(`"$message`")" 
rem }
'

    [OutputFile('.\HelloWorld.ps1.vbs')]$VBScript
}

Invoke-PipeScript .\HelloWorld.ps1.vbs
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
Inline.Basic [-CommandInfo] <CommandInfo> [[-Parameter] <IDictionary>] [[-ArgumentList] <PSObject[]>] [<CommonParameters>]
```
---



