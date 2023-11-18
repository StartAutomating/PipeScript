PipeScript.TypeConstraint
-------------------------

### Synopsis
Transpiles Type Constraints

---

### Description

Transpiles Type Constraints.

A Type Constraint is an AST expression that constrains a value to a particular type
(many languages call this a type cast).

If the type name does not exist, and is not [ordered], PipeScript will search for a transpiler and attempt to run it.

---

### Parameters
#### **TypeConstraintAST**

|Type                 |Required|Position|PipelineInput |
|---------------------|--------|--------|--------------|
|`[TypeConstraintAst]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
PipeScript.TypeConstraint -TypeConstraintAST <TypeConstraintAst> [<CommonParameters>]
```
