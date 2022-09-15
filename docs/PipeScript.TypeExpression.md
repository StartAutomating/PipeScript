
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
} | .&gt;PipeScript
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
PipeScript.TypeExpression -TypeExpressionAst &lt;TypeExpressionAst&gt; [&lt;CommonParameters&gt;]
```
---



