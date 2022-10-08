
PipeScript.ParameterTypeConstraint
----------------------------------
### Synopsis
Transpiles Parameter Type Constraints

---
### Description

Transpiles Parameter Type Constraints.

A Type Constraint is an AST expression that constrains a value to a particular type
(many languages call this a type cast).

If the type name does not exist, and is not [ordered], PipeScript will search for a transpiler and attempt to run it.

---
### Parameters
#### **TypeConstraintAST**

> **Type**: ```[TypeConstraintAst]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
PipeScript.ParameterTypeConstraint -TypeConstraintAST <TypeConstraintAst> [<CommonParameters>]
```
---



