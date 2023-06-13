
<#
.SYNOPSIS
    Gets Module Command Types
.DESCRIPTION
    Gets Custom Command Types defined in a module.

    A Module can define custom command Types by having a CommandType(s) hashtable in it's PrivateData or PSData.

    The key of the custom command type is it's name.

    The value of a custom command type can be a pattern or a hashtable of additional information.        
.EXAMPLE
    .> {
        $Module = Get-Module PipeScript
        [ModuleCommandType()]$Module
    }    
#>
[ValidateScript({
    $val = $_
    if (
        ($val.Parent -is [Management.Automation.Language.AttributedExpressionAst]) -and 
        ($val.Parent.Attribute.TypeName.Name -in 'ModuleCommandType', 'ModuleCommandTypes','ListCommandType','ListCommandTypes')
    ) {
        return $true
    }
    return $false
})]
[Alias('ModuleCommandType','ListCommandType','ListCommandTypes')]
param(
# A VariableExpression.  This variable must contain a module or name of module.
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='VariableExpressionAST')]
[Management.Automation.Language.VariableExpressionAST]
$VariableAST
)


process {

[scriptblock]::Create($({

@(

$ModuleInfo = 
    if ($targetModule -is [string]) {
        (Get-Module $targetModule)
    } elseif ($targetModule -is [Management.Automation.PSModuleInfo]) {
        $targetModule
    } else {
        Write-Error "$targetModule must be a [string] or [Management.Automation.PSModuleInfo]"    
    }


#region Search for Module Command Types
if ($ModuleInfo) {
    $ModuleCommandTypes = 
        @($ModuleInfo.PrivateData.CommandType,
        $ModuleInfo.PrivateData.CommandTypes,
        $ModuleInfo.PrivateData.PSData.CommandType,
        $ModuleInfo.PrivateData.PSData.CommandType -ne $null)[0]

    if ($ModuleCommandTypes) {
        foreach ($commandType in @($ModuleCommandTypes.GetEnumerator())) {
            if ($commandType.Value -is [Collections.IDictionary]) {
                if (-not $commandType.Value.Name) {
                    $commandType.Value["Name"] = $commandType.Key
                }
                [PSCustomObject]$commandType.Value
                
            } else {
                [PSCustomObject]@{
                    Name    = $commandType.Key
                    Pattern = $commandType.Value
                }
            }   
        }
    }
}
#endregion Search for Module Command Types

)

} -replace '\$TargetModule', "$VariableAST"))

}