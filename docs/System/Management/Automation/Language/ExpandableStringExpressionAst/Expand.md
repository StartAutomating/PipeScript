System.Management.Automation.Language.ExpandableStringExpressionAst.Expand()
----------------------------------------------------------------------------

### Synopsis
Expands a String Expression

---

### Description

Expands a PowerShell ExpandableStringExpressionAst.

Expanding a string allows for code injection, and should be used cautiously.

Also, when expanding strings during compilation, variable context is likely very different than it will be during execution.

---

### Examples
> EXAMPLE 1

```PowerShell
{"$pid"}.Ast.EndBlock.Statements[0].PipelineElements[0].Expression.Value
```

---

### Parameters
#### **Context**
The execution context

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Object]`|false   |1       |false        |

---
