Include
-------
### Synopsis
Includes Files

---
### Description

Includes Files or Functions into a Script.

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    [Include("Invoke-PipeScript")]$null
} | .>PipeScript
```

#### EXAMPLE 2
```PowerShell
{
    [Include("Invoke-PipeScript")]
    param()
} | .>PipeScript
```

#### EXAMPLE 3
```PowerShell
{
    [Include('*-*.ps1')]$psScriptRoot
} | .>PipeScript
```

---
### Parameters
#### **FilePath**

The File Path to Include



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:false



---
#### **AsByte**

If set, will include the content as a byte array



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **VariableAst**

> **Type**: ```[VariableExpressionAst]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
Include [-FilePath] <String> [-AsByte] -VariableAst <VariableExpressionAst> [<CommonParameters>]
```
---

