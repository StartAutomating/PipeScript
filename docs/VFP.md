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

|Type      |Required|Position|PipelineInput|Aliases         |
|----------|--------|--------|-------------|----------------|
|`[String]`|false   |1       |false        |ParameterSetName|

#### **Mandatory**
If set, will mark this parameter as mandatory (within this parameter set).

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **ValueFromPipelineByPropertyName**
If set, will also mark this parameter as taking ValueFromPipelineByPropertyName.

|Type      |Required|Position|PipelineInput|Aliases       |
|----------|--------|--------|-------------|--------------|
|`[Switch]`|false   |named   |false        |VFPBPN<br/>VBN|

#### **Position**
The position of the parameter.

|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |2       |false        |

---

### Syntax
```PowerShell
VFP [[-ParameterSet] <String>] [-Mandatory] [-ValueFromPipelineByPropertyName] [[-Position] <Int32>] [<CommonParameters>]
```
