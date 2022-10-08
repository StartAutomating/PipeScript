
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

> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:false



---
#### **Description**

> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Example**

> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Link**

> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ScriptBlock**

> **Type**: ```[ScriptBlock]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
Help [-Synopsis] <String> [-Description <String>] [-Example <String[]>] [-Link <String[]>] [<CommonParameters>]
```
```PowerShell
Help [-Synopsis] <String> [-Description <String>] [-Example <String[]>] [-Link <String[]>] [-ScriptBlock <ScriptBlock>] [<CommonParameters>]
```
---



