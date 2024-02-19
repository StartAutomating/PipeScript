<#
.SYNOPSIS
    Gets Language Functions by Input Type
.DESCRIPTION
    Returns a dictionary of all unique language functions that accept a pipeline parameter.

    The key will be the type of parameter accepted.
    The value will be a list of commands that accept that parameter from the pipeline. 
.NOTES
    Primitive parameter types and string types will be ignored.
#>
param()
# We want the results to be ordered (both the keys and the values)
$byInputType = [Ordered]@{}
$uniqueList = @($this.Unique | Sort-Object Order)
foreach ($uniqueCommand in $uniqueList) {
    , @(foreach ($parameterSet in $uniqueCommand.ParameterSets) {
        foreach ($parameterInSet in $parameterSet.Parameters) {
            if (-not $parameterInSet.ValueFromPipeline) { continue }
            if ($parameterInSet.ParameterType.IsPrimitive) { continue }
            if ($parameterInSet.ParameterType -eq [string]) { continue }
            if (-not $byInputType[$parameterInSet.ParameterType]) {
                $byInputType[$parameterInSet.ParameterType] = [Collections.Generic.List[PSObject]]::new()                      
            }
            $byInputType[$parameterInSet.ParameterType].Add($uniqueCommand)        
        }
    })
}
$byInputType