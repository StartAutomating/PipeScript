<#
.SYNOPSIS
    Gets dynamic parameters
.DESCRIPTION
    Gets dynamic parameters for a command
#>
param(    
    $InvocationName,

    [Collections.IDictionary]
    $DyanmicParameterOption = [Ordered]@{
        ParameterSetName='__AllParameterSets'
        NoMandatory = $true
    }    
)

$this.ExtensionsOf($InvocationName) | 
    Aspect.DynamicParameter @DyanmicParameterOption