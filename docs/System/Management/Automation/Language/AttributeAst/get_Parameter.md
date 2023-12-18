System.Management.Automation.Language.AttributeAst.get_Parameter()
------------------------------------------------------------------

### Synopsis
Gets the parameters of an attribute

---

### Description

Gets the named parameters of an attribute.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    [AnAttribute(Parameter='Value')]$null
}.Ast.EndBlock.Statements[0].PipelineElements[0].Expression.Attribute.Parameters
```

---
