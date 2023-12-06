<#
.SYNOPSIS
    Expands a String Expression
.DESCRIPTION
    Expands a PowerShell ExpandableStringExpressionAst.

    Expanding a string allows for code injection, and should be used cautiously.

    Also, when expanding strings during compilation, variable context is likely very different than it will be during execution.
.EXAMPLE
    {"$pid"}.Ast.EndBlock.Statements[0].PipelineElements[0].Expression.Value
#>
param(
# The execution context
$Context = $ExecutionContext
)

$Context.SessionState.InvokeCommand.ExpandString($this.Value)