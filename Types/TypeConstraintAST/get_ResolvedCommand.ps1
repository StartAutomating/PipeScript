<#
.SYNOPSIS
    Resolves an TypeConstraintAST to a CommandInfo
.DESCRIPTION
    Resolves an TypeConstraintAST to one or more CommandInfo Objects.
.EXAMPLE
    {
        [InvokePipeScript[a]]$null
    }.Ast.EndBlock.Statements[0].PipelineElements[0].Expression.Attribute.ResolvedCommand
.EXAMPLE
    {
        [Microsoft.PowerShell.Core.GetCommand]$null
    }.Ast.EndBlock.Statements[0].PipelineElements[0].Expression.Attribute.ResolvedCommand
.EXAMPLE
    {
        [Get_Command]$null
    }.Ast.EndBlock.Statements[0].PipelineElements[0].Expression.Attribute.ResolvedCommand
.EXAMPLE
    {
        [GetCommand]$null
    }.Ast.EndBlock.Statements[0].PipelineElements[0].Expression.Attribute.ResolvedCommand
.EXAMPLE
    {
        [cmd]$null  
    }.EndBlock.Statements[0].PipelineElements[0].Expression.Attribute.ResolvedCommand
#>
# Get the name of the transpiler.
$transpilerStepName  = 
    if ($this.TypeName.IsGeneric) {
        $this.TypeName.TypeName.Name
    } else {
        $this.TypeName.Name
    }
$decamelCase = [Regex]::new('(?<=[a-z])(?=[A-Z])')
@(
    #    If a Transpiler exists by that name, it will be returned first.
    Get-Transpiler -TranspilerName $transpilerStepName
    # Then, any periods in the attribute name will be converted to slashes, 
    $fullCommandName = $transpilerStepName -replace '\.','\' -replace 
        '_','-' # and any underscores to dashes.

    # Then, the first CamelCased code will have a - injected in between the CamelCase.    
    $fullCommandName = $decamelCase.Replace($fullCommandName, '-', 1)
    # Now we will try to find the command.
    $ExecutionContext.SessionState.InvokeCommand.GetCommand($fullCommandName, 'All')
)