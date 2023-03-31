Help
----




### Synopsis
Help Transpiler



---


### Description

The Help Transpiler allows you to write inline help without directly writing comments.



---


### Examples
#### EXAMPLE 1
```PowerShell
{
    [Help(Synopsis="The Synopsis", Description="A Description")]
    param()
```
"This Script Has Help, Without Directly Writing Comments"
    
} | .>PipeScript
#### EXAMPLE 2
```PowerShell
{
    param(
    [Help(Synopsis="X Value")]
    $x
    )
} | .>PipeScript
```

#### EXAMPLE 3
```PowerShell
{
    param(
    [Help("X Value")]
    $x
    )
} | .>PipeScript
```



---


### Parameters
#### **Synopsis**




|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|true    |1       |false        |



#### **Description**




|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |



#### **Example**




|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |named   |false        |



#### **Link**




|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |named   |false        |



#### **ScriptBlock**




|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[ScriptBlock]`|false   |named   |true (ByValue)|





---


### Syntax
```PowerShell
Help [-Synopsis] <String> [-Description <String>] [-Example <String[]>] [-Link <String[]>] [<CommonParameters>]
```
```PowerShell
Help [-Synopsis] <String> [-Description <String>] [-Example <String[]>] [-Link <String[]>] [-ScriptBlock <ScriptBlock>] [<CommonParameters>]
```
