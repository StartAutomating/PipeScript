<#
.SYNOPSIS
    Gets all Variables within an AST
.DESCRIPTION
    Gets all Variable references within a PowerShell Abstract Syntax Tree
.EXAMPLE
    {$x, $y, $z}.Ast.Variables
#>

, @(foreach ($node in $this.ByType[[Management.Automation.Language.VariableExpressionAst]]) {
    $node
})
