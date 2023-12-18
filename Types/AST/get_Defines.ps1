<#
.SYNOPSIS
    Gets all Definitions within an AST
.DESCRIPTION
    Gets all Function and Type Definitions and Parameters within a PowerShell Abstract Syntax Tree
.EXAMPLE
    {function foo() { "foo"} class bar { $bar = "none"} }.Ast.Defines
#>

, @(
    foreach ($node in $this.ByType[@(
        [Management.Automation.Language.FunctionDefinitionAst]
        [Management.Automation.Language.TypeDefinitionAst]
        [Management.Automation.Language.ParameterAst]
    )]) {
        $node
    }
)
