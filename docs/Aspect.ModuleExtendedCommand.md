Aspect.ModuleExtendedCommand
----------------------------




### Synopsis
Returns a module's extended commands



---


### Description

Returns the commands or scripts in a module that match the module command pattern.
Each returned script will be decorated with the typename(s) that match,
so that the extended commands can be augmented by the extended types system.



---


### Related Links
* [Aspect.ModuleCommandPattern](Aspect.ModuleCommandPattern.md)





---


### Examples
#### EXAMPLE 1
```PowerShell
Aspect.ModuleExtendedCommand -Module PipeScript # Should -BeOfType ([Management.Automation.CommandInfo])
```



---


### Parameters
#### **Module**

The name of a module, or a module info object.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Object]`|true    |1       |true (ByPropertyName)|



#### **Suffix**

The suffix to apply to each named capture.
Defaults to '_Command'






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|



#### **Prefix**

The prefix to apply to each named capture.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |3       |true (ByPropertyName)|



#### **FilePath**

The file path(s).  If provided, will look for commands within these paths.






|Type      |Required|Position|PipelineInput        |Aliases |
|----------|--------|--------|---------------------|--------|
|`[Object]`|false   |4       |true (ByPropertyName)|Fullname|



#### **PSTypeName**

The base PSTypeName(s).
If provided, any commands that match the pattern will apply these typenames, too.






|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |5       |false        |





---


### Syntax
```PowerShell
Aspect.ModuleExtendedCommand [-Module] <Object> [[-Suffix] <String>] [[-Prefix] <String>] [[-FilePath] <Object>] [[-PSTypeName] <String[]>] [<CommonParameters>]
```
