
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



> **Type**: ```[String]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:false



---
#### **Mandatory**

If set, the parameter will be Mandatory.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ValueFromPipeline**

If set, the parameter will also take value from Pipeline



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
VBN [[-ParameterSet] <String>] [-Mandatory] [-ValueFromPipeline] [[-Position] <Int32>] [<CommonParameters>]
```
---



