Aspect.ModuleCommandPattern
---------------------------




### Synopsis
Returns a module's command pattern



---


### Description

Returns a regular expression that can match



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





---


### Syntax
```PowerShell
Aspect.ModuleCommandPattern [-Module] <Object> [[-Suffix] <String>] [[-Prefix] <String>] [<CommonParameters>]
```
