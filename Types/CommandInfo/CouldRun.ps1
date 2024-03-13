<#
.SYNOPSIS
    Determines if a command Could Run
.DESCRIPTION
    Determines if a command Could Run, given a set of parameters (and, optionally, a parameter set name).
#>
param(
    # The parameters to check.    
    [Alias('Parameters','Param')]
    [PSObject]
    $Parameter, 

    # The parameter set name.
    [string]
    $ParameterSetName
)

if ($Parameter -isnot [Collections.IDictionary]) {
    $parameterDictionary = [Ordered]@{}
    foreach ($prop in $Parameter.psobject.properties) {
        $parameterDictionary[$prop.Name] = $prop.Value
    }
    $parameter = $parameterDictionary
}

$CouldRunOnEmpty = [Collections.Generic.List[PSObject]]::new()

:nextParameterSet foreach ($paramSet in $this.ParameterSets) {
    if ($ParameterSetName -and $paramSet.Name -ne $ParameterSetName) { continue }
    $mappedParams = [Ordered]@{} # Create a collection of mapped parameters
    $mandatories  =  # Walk thru each parameter of this command
        @(foreach ($myParam in $paramSet.Parameters) {
            if ($parameter.Contains($myParam.Name)) { # If this was in Params,
                $mappedParams[$myParam.Name] = $parameter[$myParam.Name] # then map it.
            } else {
                foreach ($paramAlias in $myParam.Aliases) { # Otherwise, check the aliases
                    if ($parameter.Contains($paramAlias)) { # and map it if the parameters had the alias.
                        $mappedParams[$myParam.Name] = $parameter[$paramAlias]
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
    if (-not $mappedParams.Count) {
        $CouldRunOnEmpty.Add($paramSet)
        continue
    }

    return $mappedParams
}

if ($CouldRunOnEmpty) {
    return @{}
}
return $false