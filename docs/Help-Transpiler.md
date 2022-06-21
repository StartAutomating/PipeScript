
Transpilers/Help.psx.ps1
------------------------
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

|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|true    |1      |false        |
---
#### **Description**

|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |named  |false        |
---
#### **Example**

|Type            |Requried|Postion|PipelineInput|
|----------------|--------|-------|-------------|
|```[String[]]```|false   |named  |false        |
---
#### **Link**

|Type            |Requried|Postion|PipelineInput|
|----------------|--------|-------|-------------|
|```[String[]]```|false   |named  |false        |
---
#### **ScriptBlock**

|Type               |Requried|Postion|PipelineInput |
|-------------------|--------|-------|--------------|
|```[ScriptBlock]```|false   |named  |true (ByValue)|
---
### Syntax
```PowerShell
Transpilers/Help.psx.ps1 [-Synopsis] <String> [-Description <String>] [-Example <String[]>] [-Link <String[]>] [<CommonParameters>]
```
```PowerShell
Transpilers/Help.psx.ps1 [-Synopsis] <String> [-Description <String>] [-Example <String[]>] [-Link <String[]>] [-ScriptBlock <ScriptBlock>] [<CommonParameters>]
```
---


