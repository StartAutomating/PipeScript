Perl.Template
-------------




### Synopsis
Perl Template Transpiler.



---


### Description

Allows PipeScript to generate Perl.

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
Perl.Template -CommandInfo <CommandInfo> [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
```PowerShell
Perl.Template -AsTemplateObject [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```

