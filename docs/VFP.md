
VFP
---
### Synopsis
ValueFromPipline Shorthand

---
### Description

This is syntax shorthand to create [Parameter] attributes that take ValueFromPipeline.

---
### Parameters
#### **ParameterSet**

The parameter set name.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |1      |false        |
---
#### **Mandatory**

If set, will mark this parameter as mandatory (within this parameter set).



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **ValueFromPipelineByPropertyName**

If set, will also mark this parameter as taking ValueFromPipelineByPropertyName.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **Position**

The position of the parameter.



|Type         |Requried|Postion|PipelineInput|
|-------------|--------|-------|-------------|
|```[Int32]```|false   |2      |false        |
---
### Syntax
```PowerShell
VFP [[-ParameterSet] <String>] [-Mandatory] [-ValueFromPipelineByPropertyName] [[-Position] <Int32>] [<CommonParameters>]
```
---


