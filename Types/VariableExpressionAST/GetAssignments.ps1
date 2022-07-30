<#
.SYNOPSIS
    Gets assignments of a variable
.DESCRIPTION
    Searches the abstract syntax tree for assignments of the variable.
.EXAMPLE
    {
        $x = 1
        $y = 2
        $x * $y
    }.Ast.EndBlock.Statements[-1].PipelineElements[0].Expression.Left.GetAssignments()
.EXAMPLE
    {
        [int]$x, [int]$y = 1, 2
        $x * $y
    }.Ast.EndBlock.Statements[-1].PipelineElements[0].Expression.Left.GetAssignments()
.EXAMPLE
    {
        param($x, $y)        
        $x * $y
    }.Ast.EndBlock.Statements[-1].PipelineElements[0].Expression.Left.GetAssignments()
#>
param()

$astVariableName = "$this"
$variableFoundAt = @{}
foreach ($parent in $this.GetLineage()) {
    $parent.FindAll({
        param($ast)
        $IsAssignment = 
            (
                $ast -is [Management.Automation.Language.AssignmentStatementAst] -and
                $ast.Left.Find({
                    param($leftAst)
                    $leftAst -is [Management.Automation.Language.VariableExpressionAST] -and
                    $leftAst.Extent.ToString() -eq $astVariableName
                }, $false)
            ) -or (
                $ast -is [Management.Automation.Language.ParameterAst] -and 
                $ast.Name.ToString() -eq $astVariableName
            )

        if ($IsAssignment -and -not $variableFoundAt[$ast.Extent.StartOffset]) {
            $variableFoundAt[$ast.Extent.StartOffset] = $ast
            $ast
        }        
    }, $false)
}
