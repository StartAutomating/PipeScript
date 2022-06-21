<#
#>
[ValidateScript({
    $_.Parent -is [Management.Automation.Language.ParameterAst]
})]
param(
[Parameter(Mandatory,ParameterSetName='ParameterAst',ValueFromPipeline)]
[Management.Automation.Language.AttributeAst]
$AttributeAst
)

process {
    # First, find the script block that this parameter lives within.
    # We may need it to determine any greater context
    $astPointer = $AttributeAst
    $scriptBlockContext =
        do { # do this by walking up the parents
            $astPointer = $astPointer.Parent
        } while ($astPointer -isnot [Management.Automation.Language.ScriptBlockAst]) # until it is a script block AST.

    
    $isRealType = $AttributeAst.TypeName.GetReflectionType()
    if ($isRealType) { return }
    Invoke-PipeScript -AttributeSyntaxTree $AttributeAst               
}