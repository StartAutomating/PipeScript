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



> **Type**: ```[String]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:false



---
#### **Mandatory**

If set, will mark this parameter as mandatory (within this parameter set).



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ValueFromPipelineByPropertyName**

If set, will also mark this parameter as taking ValueFromPipelineByPropertyName.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Position**

The position of the parameter.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:false



---
### Syntax
```PowerShell
VFP [[-ParameterSet] <String>] [-Mandatory] [-ValueFromPipelineByPropertyName] [[-Position] <Int32>] [<CommonParameters>]
```
---

