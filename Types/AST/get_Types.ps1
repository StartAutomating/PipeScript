<#
.SYNOPSIS
    Gets all Types within an AST
.DESCRIPTION
    Gets all Types referenced within a PowerShell Abstract Syntax Tree
.EXAMPLE
    {[int];[psobject];[xml]}.Ast.Types
#>

,@(foreach ($node in $this.ByType[[Management.Automation.Language.TypeExpressionAst]]) {
    $node
})
