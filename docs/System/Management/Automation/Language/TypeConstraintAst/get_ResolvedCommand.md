System.Management.Automation.Language.TypeConstraintAst.get_ResolvedCommand()
-----------------------------------------------------------------------------

### Synopsis
Resolves an TypeConstraintAST to a CommandInfo

---

### Description

Resolves an TypeConstraintAST to one or more CommandInfo Objects.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    [InvokePipeScript[a]]$null
}.Ast.EndBlock.Statements[0].PipelineElements[0].Expression.Attribute.ResolvedCommand
```
> EXAMPLE 2

```PowerShell
{
    [Microsoft.PowerShell.Core.GetCommand]$null
}.Ast.EndBlock.Statements[0].PipelineElements[0].Expression.Attribute.ResolvedCommand
```
> EXAMPLE 3

```PowerShell
{
    [Get_Command]$null
}.Ast.EndBlock.Statements[0].PipelineElements[0].Expression.Attribute.ResolvedCommand
```
> EXAMPLE 4

```PowerShell
{
    [GetCommand]$null
}.Ast.EndBlock.Statements[0].PipelineElements[0].Expression.Attribute.ResolvedCommand
```
> EXAMPLE 5

```PowerShell
{
    [cmd]$null  
}.EndBlock.Statements[0].PipelineElements[0].Expression.Attribute.ResolvedCommand
Get the name of the transpiler.
```

---
