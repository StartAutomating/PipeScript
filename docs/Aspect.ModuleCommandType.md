Aspect.ModuleCommandType
------------------------




### Synopsis
Outputs a module's command types



---


### Description

Outputs the command types defined in a module's manifest.



---


### Examples
#### EXAMPLE 1
```PowerShell
# Outputs a series of PSObjects with information about command types.
# The two primary pieces of information are the `.Name` and `.Pattern`.
Aspect.ModuleCommandType -Module PipeScript # Should -BeOfType ([PSObject])
```



---


### Parameters
#### **Module**

The name of a module, or a module info object.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Object]`|true    |1       |true (ByPropertyName)|





---


### Syntax
```PowerShell
Aspect.ModuleCommandType [-Module] <Object> [<CommonParameters>]
```
