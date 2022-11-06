PipeScript.TypeExpression
-------------------------
### Synopsis
The PipeScript TypeExpression Transpiler

---
### Description

Type Expressions may be transpiled.

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    [include[a.ps1]]
} | .>PipeScript
```

---
### Parameters
#### **TypeExpressionAst**

The attributed expression



> **Type**: ```[TypeExpressionAst]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
PipeScript.TypeExpression -TypeExpressionAst <TypeExpressionAst> [<CommonParameters>]
```
---

