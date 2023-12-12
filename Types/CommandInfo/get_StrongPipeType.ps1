<#
.SYNOPSIS
    Gets strongly piped types for a command.
.DESCRIPTION
    Gets the strong types that a given command can accept as a ValueFromPipeline parameter.
#>
, @(foreach ($parameterSet in $this.ParameterSets) {
    foreach ($parameterInSet in $parameterSet.Parameters) {
        if (-not $parameterInSet.ValueFromPipeline) { continue }
        if ((-not $parameterInSet.ParameterType.IsPrimitive) -and  
            $parameterInSet.ParameterType -notin [string],[object],[psobject]) {
            $parameterInSet.ParameterType
        }        
    }
})

