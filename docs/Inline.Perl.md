
Inline.Perl
-----------
### Synopsis
Perl Inline PipeScript Transpiler.

---
### Description

Transpiles Perl with Inline PipeScript into Perl.

Also Transpiles Plain Old Document

PipeScript can be embedded in a Plain Old Document block that starts with ```=begin PipeScript``` and ends with ```=end PipeScript```.

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    $HelloWorldPerl = @'
=begin PipeScript
$msg = "hello", "hi", "hey", "howdy" | Get-Random
"print(" + '"' + $msg + '");'
=end   PipeScript
'@
```
[Save(".\HelloWorld.ps1.pl")]$HelloWorldPerl
}

.> .\HelloWorld.ps1.pl
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
Inline.Perl [-CommandInfo] <CommandInfo> [[-Parameter] <IDictionary>] [[-ArgumentList] <PSObject[]>] [<CommonParameters>]
```
---



