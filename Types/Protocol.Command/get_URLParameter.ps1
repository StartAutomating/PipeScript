<#
.SYNOPSIS
    Gets a Protocol's URL parameter
.DESCRIPTION
    Gets a Protocol Command's URL parameter.
#>
foreach ($param in $this.Parameters.GetEnumerator()) {
    if ($param.Value.ParameterType -eq [uri]) {
        return $param.Value
    }
}