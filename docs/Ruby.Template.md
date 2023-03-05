Ruby.Template
-------------




### Synopsis
Ruby Template Transpiler.



---


### Description

Allows PipeScript to generate Ruby.

PipeScript can be embedded in a multiline block that starts with ```=begin{``` and ends with } (followed by ```=end```)



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
Ruby.Template -CommandInfo <CommandInfo> [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
```PowerShell
Ruby.Template -AsTemplateObject [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```

