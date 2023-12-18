System.Management.Automation.Language.VariableExpressionAst.GetVariableType()
-----------------------------------------------------------------------------

### Synopsis
Gets a Variable's Likely Type

---

### Description

Determines the type of a variable.

This looks for the closest assignment statement and uses this to determine what type the variable is likely to be.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    [int]$x = 1
    $y = 2
    $x + $y
}.Ast.EndBlock.Statements[-1].PipelineElements[0].Expression.Left.GetVariableType()
# Should -Be ([int])
```
> EXAMPLE 2

```PowerShell
{
    $x = Get-Process        
    $x + $y
}.Ast.EndBlock.Statements[-1].PipelineElements[0].Expression.Left.GetVariableType()
# Should -Be ([Diagnostics.Process])
```
> EXAMPLE 3

```PowerShell
{
    $x = [type].name
    $x        
}.Ast.EndBlock.Statements[-1].PipelineElements[0].Expression.GetVariableType()
```

---

### Notes
Subject to revision and improvement.  While this covers many potential scenarios, it does not always

---
