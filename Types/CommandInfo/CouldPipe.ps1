param([PSObject]$InputObject)

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
        if ($myParam.ValueFromPipeline) {
            $potentialPSTypeNames = @($myParam.Attributes.PSTypeName) -ne ''
            if ($potentialPSTypeNames)  {                                
                foreach ($potentialTypeName in $potentialPSTypeNames) {
                    if ($potentialTypeName -and $InputObject.pstypenames -contains $potentialTypeName) {
                        $mappedParams[$myParam.Name] = $params[$myParam.Name] = $InputObject
                        continue nextParameter
                    }
                }                                    
            }
            # and we have an input object
            elseif ($null -ne $inputObject -and
                (
                    # of the exact type
                    $myParam.ParameterType -eq $inputObject.GetType() -or
                    # (or a subclass of that type)
                    $inputObject.GetType().IsSubClassOf($myParam.ParameterType) -or
                    # (or an inteface of that type)
                    ($myParam.ParameterType.IsInterface -and $InputObject.GetType().GetInterface($myParam.ParameterType))
                )
            ) {
                # then map the parameter.
                $mappedParams[$myParam.Name] = $params[$myParam.Name] = $InputObject
            }
        }
    }
    # Check for parameter validity.
    foreach ($mappedParamName in @($mappedParams.Keys)) {
        if (-not $this.IsParameterValid($mappedParamName, $mappedParams[$mappedParamName])) {
            $mappedParams.Remove($mappedParamName)
        }
    }
    if ($mappedParams.Count -gt 0) {
        return $mappedParams
    }
}