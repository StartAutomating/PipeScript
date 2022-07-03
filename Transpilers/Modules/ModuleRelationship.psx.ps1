
<#
.SYNOPSIS
    Gets Module Relationships
.DESCRIPTION
    Gets Modules that are related to a given module.

    Modules can be related to each other by a few mechanisms:

    * A Module Can Include another Module's Name in it's ```.PrivateData.PSData.Tags```
    * A Module Can include data for another module it it's ```.PrivataData.```
.EXAMPLE
    .> {
        $Module = Get-Module PipeScript
        [ModuleRelationships()]$Module
    }    
#>
[ValidateScript({
    $val = $_
    if (
        ($val.Parent -is [Management.Automation.Language.AttributedExpressionAst]) -and 
        ($val.Parent.Attribute.TypeName.Name -in 'RelatedModules', 'RelatedModule', 'ModuleRelationships')
    ) {
        return $true
    }
    return $false
})]
[Alias('RelatedModules', 'RelatedModule','ModuleRelationships')]
param(
# A VariableExpression.  This variable must contain a module or name of module.
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='VariableExpressionAST')]
[Management.Automation.Language.VariableExpressionAST]
$VariableAST
)


process {

[scriptblock]::Create($({

@(

$MyModuleName, $myModule = 
    if ($targetModule -is [string]) {
        $targetModule, (Get-Module $targetModule)
    } elseif ($targetModule -is [Management.Automation.PSModuleInfo]) {
        $targetModule.Name, $targetModule
    } else {
        Write-Error "$targetModule must be a [string] or [Management.Automation.PSModuleInfo]"    
    }


#region Search for Module Relationships
if ($myModule -and $MyModuleName) {
    foreach ($loadedModule in Get-Module) { # Walk over all modules.
        if ( # If the module has PrivateData keyed to this module
            $loadedModule.PrivateData.$myModuleName
        ) {
            # Determine the root of the module with private data.            
            $relationshipData = $loadedModule.PrivateData.$myModuleName
            [PSCustomObject][Ordered]@{
                PSTypeName     = 'Module.Relationship'
                Module        = $myModule
                RelatedModule = $loadedModule
                PrivateData   = $loadedModule.PrivateData.$myModuleName
            }
        }
        elseif ($loadedModule.PrivateData.PSData.Tags -contains $myModuleName) {
            [PSCustomObject][Ordered]@{
                PSTypeName     = 'Module.Relationship'
                Module        = $myModule
                RelatedModule = $loadedModule
                PrivateData   = @{}
            }
        }
    }
}
#endregion Search for Module Relationships

)

} -replace '\$TargetModule', "$VariableAST"))

}