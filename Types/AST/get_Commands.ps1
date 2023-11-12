<#
.SYNOPSIS
    Gets all Commands within an AST
.DESCRIPTION
    Gets all Command references within a PowerShell Abstract Syntax Tree
.EXAMPLE
    {Get-Process}.Ast.Commands
#>

,@(foreach ($node in $this.ByType[[Management.Automation.Language.CommandAST]]) {
    $node
})
