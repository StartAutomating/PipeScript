System.Management.Automation.Language.AttributeAst.get_ResolvedCommand()
------------------------------------------------------------------------

### Synopsis
Resolves an Attribute to a CommandInfo

---

### Description

Resolves an Attribute to one or more CommandInfo.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    [InvokePipeScript()]$null
}.Ast.EndBlock.Statements[0].PipelineElements[0].Expression.Attribute.ResolvedCommand
```
> EXAMPLE 2

```PowerShell
{
    [Microsoft.PowerShell.Core.GetCommand()]$null
}.Ast.EndBlock.Statements[0].PipelineElements[0].Expression.Attribute.ResolvedCommand
```
> EXAMPLE 3

```PowerShell
{
    [Get_Command()]$null
}.Ast.EndBlock.Statements[0].PipelineElements[0].Expression.Attribute.ResolvedCommand
```
> EXAMPLE 4

```PowerShell
{
    [GetCommand()]$null
}.Ast.EndBlock.Statements[0].PipelineElements[0].Expression.Attribute.ResolvedCommand
```
> EXAMPLE 5

```PowerShell
{
    [cmd()]$null  
}.EndBlock.Statements[0].PipelineElements[0].Expression.Attribute.ResolvedCommand
Get the name of the transpiler.
```

---
