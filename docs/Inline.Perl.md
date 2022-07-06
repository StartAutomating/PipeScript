
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



|Type          |Requried|Postion|PipelineInput |
|--------------|--------|-------|--------------|
|```[Object]```|true    |1      |true (ByValue)|
---
### Syntax
```PowerShell
Inline.Perl [-CommandInfo] <Object> [<CommonParameters>]
```
---


