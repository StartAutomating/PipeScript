<#
.SYNOPSIS
    Determines if a command is strongly piped.
.DESCRIPTION
    Determines if a command uses strong typing on at least one ValueFromPipeline parameter.
#>
$weakTypeList = [string],[object],[psobject], [string[]],[object[]],[psobject[]]
foreach ($parameterSet in $this.ParameterSets) {
    foreach ($parameterInSet in $parameterSet.Parameters) {
        if (-not $parameterInSet.ValueFromPipeline) { continue }
        if ((-not $parameterInSet.ParameterType.IsPrimitive) -and  
            $parameterInSet.ParameterType -notin $weakTypeList) {
            return $true
        }        
    }
}
return $false
