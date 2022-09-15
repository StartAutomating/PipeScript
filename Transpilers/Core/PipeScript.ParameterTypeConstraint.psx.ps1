<#
.SYNOPSIS
    Transpiles Parameter Type Constraints
.DESCRIPTION
    Transpiles Parameter Type Constraints.
    
    A Type Constraint is an AST expression that constrains a value to a particular type
    (many languages call this a type cast).

    If the type name does not exist, and is not [ordered], PipeScript will search for a transpiler and attempt to run it.
#>
[ValidateScript({
    if (-not $_.Parent -is [Management.Automation.Language.ParameterAst]) {
        return $false
    }

    $isRealType = $_.TypeName.GetReflectionType()
    if ($isRealType) { return $false }
    return $true
})]
param(
[Parameter(Mandatory,ParameterSetName='ParameterAst',ValueFromPipeline)]
[Management.Automation.Language.TypeConstraintAst]
$TypeConstraintAST
)

process {
    # First, find the script block that this parameter lives within.
    # We may need it to determine any greater context
    $astPointer = $TypeConstraintAST
    $scriptBlockContext =
        do { # do this by walking up the parents
            $astPointer = $astPointer.Parent
        } while ($astPointer -isnot [Management.Automation.Language.ScriptBlockAst]) # until it is a script block AST.

    
    $isRealType = $TypeConstraintAST.TypeName.GetReflectionType()
    if ($isRealType) { return }
    if ($TypeConstraintAST.TypeName.Name -eq 'ordered') {
        return
    }
    try {
        Invoke-PipeScript -TypeConstraint $TypeConstraintAST
    } catch {
        $errorInfo = $_
        $PSCmdlet.WriteError($errorInfo)
    }
}
