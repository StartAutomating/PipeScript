param(
[Type]
$Type
)

$parameterSets =
    if ($this.ResolvedCommand.ParameterSets) {
        $this.ResolvedCommand.ParameterSets
    } elseif ($this.ParameterSets) {
        $this.ParameterSets
    }

:nextParameterSet foreach ($paramSet in $parameterSets) {
    if ($ParameterSetName -and $paramSet.Name -ne $ParameterSetName) { continue }
    $params = @{}
    $mappedParams = [Ordered]@{} # Create a collection of mapped parameters
    # Walk thru each parameter of this command
    :nextParameter foreach ($myParam in $paramSet.Parameters) {
        # If the parameter is ValueFromPipeline
        if ($myParam.ValueFromPipeline -and
            (
        
                # of the exact type
                $myParam.ParameterType -eq $type -or
                # (or a subclass of that type)
                $type.IsSubClassOf($myParam.ParameterType) -or
                # (or an inteface of that type)
                ($myParam.ParameterType.IsInterface -and $type.GetInterface($myParam.ParameterType))
            )
        ) {
            return $true
        }        
    }
}

return $false