<#
.SYNOPSIS
    Determines if a command is strongly piped.
.DESCRIPTION
    Determines if a command uses strong typing on at least one ValueFromPipeline parameter.
#>
foreach ($parameterSet in $this.ParameterSets) {
    foreach ($parameterInSet in $parameterSet.Parameters) {
        if (-not $parameterInSet.ValueFromPipeline) { continue }
        if ((-not $parameterInSet.ParameterType.IsPrimitive) -and  
            $parameterInSet.ParameterType -notin [string],[object],[psobject]) {
            return $true
        }        
    }
}
return $false
