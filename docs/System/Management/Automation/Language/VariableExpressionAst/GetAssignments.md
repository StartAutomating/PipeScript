System.Management.Automation.Language.VariableExpressionAst.GetAssignments()
----------------------------------------------------------------------------

### Synopsis
Gets assignments of a variable

---

### Description

Searches the abstract syntax tree for assignments of the variable.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    $x = 1
    $y = 2
    $x * $y
}.Ast.EndBlock.Statements[-1].PipelineElements[0].Expression.Left.GetAssignments()
```
> EXAMPLE 2

```PowerShell
{
    [int]$x, [int]$y = 1, 2
    $x * $y
}.Ast.EndBlock.Statements[-1].PipelineElements[0].Expression.Left.GetAssignments()
```
> EXAMPLE 3

```PowerShell
{
    param($x, $y)        
    $x * $y
}.Ast.EndBlock.Statements[-1].PipelineElements[0].Expression.Left.GetAssignments()
```

---
