VBN
---
### Synopsis
ValueFromPiplineByPropertyName Shorthand

---
### Description

This is syntax shorthand to create [Parameter] attributes that take ValueFromPipelineByPropertyName.

---
### Parameters
#### **ParameterSet**

The name of the parameter set






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |1       |false        |



---
#### **Mandatory**

If set, the parameter will be Mandatory.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



---
#### **ValueFromPipeline**

If set, the parameter will also take value from Pipeline






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



---
#### **Position**

The position of the parameter.






|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |2       |false        |



---
### Syntax
```PowerShell
VBN [[-ParameterSet] <String>] [-Mandatory] [-ValueFromPipeline] [[-Position] <Int32>] [<CommonParameters>]
```
---

