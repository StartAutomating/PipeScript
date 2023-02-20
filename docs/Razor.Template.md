Razor.Template
--------------




### Synopsis
Razor Template Transpiler.



---


### Description

Allows PipeScript to generate Razor.

Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.

JavaScript/CSS comment blocks like ```/*{}*/``` will also be treated as blocks of PipeScript.

Razor comment blocks like ```@*{}*@``` will also be treated as blocks of PipeScript.



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
Razor.Template -CommandInfo <CommandInfo> [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
```PowerShell
Razor.Template -AsTemplateObject [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```

