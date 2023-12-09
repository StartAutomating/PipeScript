System.Management.Automation.Language.TypeConstraintAst.get_ArgumentList()
--------------------------------------------------------------------------

### Synopsis
Gets arguments of a type constraint

---

### Description

Gets the arguments from a type constraint.

This will treat any generic type specifiers as potential parameters, and other type specifiers as arguments.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    [a[b[c],c]]'d'
}.Ast.EndBlock.Statements[0].PipelineElements[0].Expression.Type.ArgumentList
```

---
