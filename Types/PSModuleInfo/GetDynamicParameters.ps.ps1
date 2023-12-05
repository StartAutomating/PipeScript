<#
.SYNOPSIS
    Gets dynamic parameters
.DESCRIPTION
    Gets dynamic parameters for a command
#>
param()

$DynamicParameterSplat = [Ordered]@{}
$dynamicParametersFrom =@(foreach ($arg in $args | & { process{ $_ } } ) {
    if ($arg -is [Management.Automation.CommandInfo] -or $arg -is [ScriptBlock]) {
        $arg
    }
    if ($arg -is [Collections.IDictionary]) {
        foreach ($keyValuePair in $arg.GetEnumerator()) {
            $DynamicParameterSplat[$keyValuePair.Key] = $keyValuePair.Value
        }
    }
})

if (-not $dynamicParametersFrom) { return }

$dynamicParametersFrom | 
    Aspect.DynamicParameter @DyanmicParameterOption