param([Collections.IDictionary]$params, [string]$ParameterSetName)

:nextParameterSet foreach ($paramSet in $this.ParameterSets) {
    if ($ParameterSetName -and $paramSet.Name -ne $ParameterSetName) { continue }
    $mappedParams = [Ordered]@{} # Create a collection of mapped parameters
    $mandatories  =  # Walk thru each parameter of this command
        @(foreach ($myParam in $paramSet.Parameters) {
            if ($params.Contains($myParam.Name)) { # If this was in Params,
                $mappedParams[$myParam.Name] = $params[$myParam.Name] # then map it.
            } else {
                foreach ($paramAlias in $myParam.Aliases) { # Otherwise, check the aliases
                    if ($params.Contains($paramAlias)) { # and map it if the parameters had the alias.
                        $mappedParams[$myParam.Name] = $params[$paramAlias]
                        break
                    }
                }
            }
            if ($myParam.IsMandatory) { # If the parameter was mandatory,
                $myParam.Name # keep track of it.
            }
        })

    # Check for parameter validity.
    foreach ($mappedParamName in @($mappedParams.Keys)) {
        if (-not $this.IsParameterValid($mappedParamName, $mappedParams[$mappedParamName])) {
            $mappedParams.Remove($mappedParamName)
        }
    }
    
    foreach ($mandatoryParam in $mandatories) { # Walk thru each mandatory parameter.
        if (-not $mappedParams.Contains($mandatoryParam)) { # If it wasn't in the parameters.
            continue nextParameterSet
        }
    }
    return $mappedParams
}
return $false