<#
.SYNOPSIS
    Maps Natural Language Syntax to PowerShell Parameters
.DESCRIPTION
    Maps a statement in natural language syntax to a set of PowerShell parameters.

    All parameters will be collected.
    
    For the purposes of natural language processing ValueFromPipeline will be ignored.
    
    The order the parameters is declared takes precedence over Position attributes.
#>
param()

# Because we want to have flexible open-ended arguments here, we do not hard-code any arguments.
# we parse them.
$IsRightToLeft = $false
foreach ($arg in $arguments) {
    if ($arg -match '^-{0,2}RightToLeft$') {
        # If -RightToLeft was passed
        $IsRightToLeft = $true
    }
}

$mappedParameters = [Ordered]@{}
$sentence = [Ordered]@{
    PSTypeName='PipeScript.Sentence'
    Command   = $null
}


$commandAst = $this
$commandElements = @($commandAst.CommandElements)
# If we are going right to left, reverse the command elements


if ($IsRightToLeft) {
    [Array]::Reverse($commandElements)
}

# The first command element should be the name of the command.
$firstCommandElement = $commandElements[0]
$commandName = ''
$potentialCommands = 
    @(if ($firstCommandElement.Value -and $firstCommandElement.StringConstantType -eq 'BareWord') {    
        $commandName = $firstCommandElement.Value
        $foundTranspiler = Get-Transpiler -TranspilerName $commandName    
        if ($foundTranspiler) {
            foreach ($transpiler in $foundTranspiler) {
                if ($transpiler.Validate($commandAst)) { 
                    $transpiler
                }
            }
        } else {
            $ExecutionContext.SessionState.InvokeCommand.GetCommands($commandName, 'All', $true)
        }
    })

if (-not $potentialCommands) {
    [PSCustomObject][Ordered]@{
        PSTypeName = 'PipeScript.Sentence'
        Keyword    = $commandName
        Command    = $null
        Arguments  = $commandElements[1..$commandElements.Length]
    }
}


$mappedParameters = [Ordered]@{}

foreach ($potentialCommand in $potentialCommands) {
    <#
    Each potential command can be thought of as a simple sentence with (mostly) natural syntax
    
    command <parametername> ...<parameterargument> (etc)     
        
    either more natural or PowerShell syntax should be allowed, for example:

    all functions can Quack {
        "quack"
    }

    would map to the command all and the parameters -Function and -Can (with the arguments Quack and {"quack"})

    Assuming -Functions was a `[switch]` or an alias to a `[switch]`, it will match that `[switch]` and only that switch.

    If -Functions was not a `[switch]`, it will match values from that point.

    If the parameter type is not a list or PSObject, only the next parameter will be matched.

    If the parameter type *is* a list or an PSObject, 
    or ValueFromRemainingArguments is present and no named parameters were found,
    then all remaining arguments will be matched until the next named parameter is found.
    
    _Aliasing is important_ when working with a given parameter.  The alias, _not_ the parameter name, will be what is mapped.

    #>

    # Cache the potential parameters
    $potentialParameters = $potentialCommand.Parameters

    # Assume the current parameter is empty,
    $currentParameter  = ''
    # the current parameter metadata is null,
    $currentParameterMetadata = $null
    # there is no current clause,
    $currentClause = @()
    # and there are no unbound parameters.            
    $unboundParameters = @()
    $clauses = @()

    # Walk over each command element in a for loop (we may adjust the index when we match)
    for ($commandElementIndex = 1 ;$commandElementIndex -lt $commandElements.Count; $commandElementIndex++) {
        $commandElement = $CommandElements[$commandElementIndex]
        # by default, we assume we haven't found a parameter.
        $parameterFound  = $false

        # That assumption is quickly challenged if the AST type was CommandParameter
        if ($commandElement -is [CommandParameterAst]) {
            # If there were already clauses, finalize them before we start this clause
            if ($currentClause) {                
                $clauses += [PSCustomObject][Ordered]@{
                    PSTypeName    = 'PipeScript.Sentence.Clause'
                    Name          = if ($currentParameter) { $currentParameter} else { '' }
                    ParameterName = if ($currentParameterMetadata) { $currentParameterMetadata.Name } else { '' }
                    Words         = $currentClause
                }
            }

            $commandParameter = $commandElement
            # In that case, we know the name they want to use for the parameter                      
            $currentParameter = $commandParameter.ParameterName
            
            $currentClause = @($currentParameter)
            # We need to get the parameter metadata as well.
            $currentParameterMetadata = 
                # If it was the real name of a parameter, this is easy
                if ($potentialCommand.Parameters[$currentParameter]) {
                    $potentialCommand.Parameters[$currentParameter]
                    $parameterFound = $true
                }
                else {
                    # Otherwise, we need to search each parameter for aliases.
                    foreach ($cmdParam in $potentialCommand.Parameters.Values) {
                        if ($cmdParam.Aliases -contains $currentParameter) {
                            $parameterFound = $true
                            $cmdParam
                            break
                        }                            
                    }
                }
            
            # If the parameter had an argument
            if ($commandParameter.Argument) {
                # Use that argument
                if ($mappedParameters[$currentParameter]) {
                    $mappedParameters[$currentParameter] = @($mappedParameters[$currentParameter]) + @(
                        $commandParameter.Argument
                    )                    
                } else {
                    $mappedParameters[$currentParameter] = $commandParameter.Argument
                }
                # and move onto the next element.                
                $clauses += [PSCustomObject][Ordered]@{
                    PSTypeName    = 'PipeScript.Sentence.Clause'
                    Name          = if ($currentParameter) { $currentParameter} else { '' }
                    ParameterName = if ($currentParameterMetadata) { $currentParameterMetadata.Name } else { '' }
                    Words         = $currentClause
                }
                $currentParameter = ''
                $currentParameterMetadata = $null
                
                $currentClause = @()
                continue
            }
            # Since we have found a parameter, we advance the index.
            $commandElementIndex++
        }
        # If the command element was a bareword, it could also be the name of a parameter
        elseif ($commandElement.Value -and $commandElement.StringConstantType -eq 'Bareword') {
            # We need to know the name of the parameter as it was written.
            # However, we also want to allow --parameters and /parameters,
            $potentialParameterName = $commandElement.Value
            # therefore, we will compare against the potential name without leading dashes or slashes.
            $dashAndSlashlessName   = $potentialParameterName -replace '^[-/]{0,}'

            # If no parameter was found but a parameter has ValueFromRemainingArguments, we will map to that.                        
            $valueFromRemainingArgumentsParameter = $null

            # Walk over each potential parameter in the command
            foreach ($potentialParameter in $potentialParameters.Values) {
                $parameterFound = $(
                    # If the parameter name matches,
                    if ($potentialParameter.Name -eq $dashAndSlashlessName) {
                        $true # we've found it,
                    } else {
                        # otherwise, we have to check each alias.
                        foreach ($potentialAlias in $potentialParameter.Aliases) {
                            if ($potentialAlias -eq $dashAndSlashlessName) {
                                $true                                    
                                break
                            }
                        }
                    }    
                )

                # If we found the parameter
                if ($parameterFound) {
                    if ($currentClause) {
                        $clauses += [PSCustomObject][Ordered]@{
                            PSTypeName    = 'PipeScript.Sentence.Clause'
                            Name          = if ($currentParameter) { $currentParameter} else { '' }
                            ParameterName = if ($currentParameterMetadata) { $currentParameterMetadata.Name } else { '' }
                            Words         = $currentClause
                        }                         
                    }

                    # keep track of of it and advance the index.
                    $currentParameter = $potentialParameterName                    
                    $currentParameterMetadata = $potentialParameter                    
                    $currentClause = @($commandElement)
                    $commandElementIndex++
                    break
                }
                else {
                    # If we did not, check the parameter for .ValueFromRemainingArguments
                    foreach ($attr in $potentialParameter.Attributes) {
                        if ($attr.ValueFromRemainingArguments) {
                            $valueFromRemainingArgumentsParameter = $potentialParameter
                            break
                        }
                    }                    
                }
            }
        }

        # If we have our current parameter, but it is a switch,
        if ($currentParameter -and $currentParameterMetadata.ParameterType -eq [switch]) {        
            $mappedParameters[$currentParameter] = $true # set it             
            if ($currentClause) {                
                $clauses += [PSCustomObject][Ordered]@{
                    PSTypeName    = 'PipeScript.Sentence.Clause'
                    Name          = if ($currentParameter) { $currentParameter} else { '' }
                    ParameterName = if ($currentParameterMetadata) { $currentParameterMetadata.Name } else { '' }
                    Words         = $currentClause
                }                                     
            }
            $currentParameter = '' # and clear the current parameter.
            $currentClause = @()            
        }


        # Refersh our $commandElement, as the index may have changed.
        $commandElement = $CommandElements[$commandElementIndex]

        # If we have a ValueFromRemainingArguments but no current parameter mapped
        if ($valueFromRemainingArgumentsParameter -and -not $currentParameter) {
            # assume the ValueFromRemainingArguments parameter is the current parameter.
            $currentParameter = $valueFromRemainingArgumentsParameter.Name
            $currentParameterMetadata = $valueFromRemainingArgumentsParameter            
            $currentClause = @()
        }

        # If we have a current parameter
        if ($currentParameter) {
            # Map the current element to this parameter.
            $mappedParameters[$currentParameter] = 
                if ($mappedParameters[$currentParameter]) {
                    @($mappedParameters[$currentParameter]) + @($commandElement)
                } else {
                    if ($commandElement.Value) {
                        $commandElement.Value
                    } 
                    elseif ($commandElement -is [ScriptBlockExpressionAst]) {
                        [ScriptBlock]::Create($commandElement.Extent.ToString() -replace '^\{' -replace '\}$')
                    }
                    else {
                        $commandElement
                    }
                }
            $currentClause += $commandElement
        } else {
            # otherwise add the command element to our unbound parameters.
            $unboundParameters +=
                if ($commandElement.Value) {
                    $commandElement.Value
                } 
                elseif ($commandElement -is [ScriptBlockExpressionAst]) {
                    [ScriptBlock]::Create($commandElement.Extent.ToString() -replace '^\{' -replace '\}$')
                }
                else {
                    $commandElement
                }
            $currentClause += $commandElement
        }

    }

    if ($currentClause) {
        $clauses += [PSCustomObject][Ordered]@{
            PSTypeName    = 'PipeScript.Sentence.Clause'
            Name          = if ($currentParameter) { $currentParameter} else { '' }
            ParameterName = if ($currentParameterMetadata) { $currentParameterMetadata.Name } else { '' }
            Words         = $currentClause
        }                   
    }

    if ($potentialCommand -isnot [Management.Automation.ApplicationInfo] -and 
        @($mappedParameters.Keys) -match '^[-/]') {
        $keyIndex = -1
        :nextParameter foreach ($mappedParamName in @($mappedParameters.Keys)) {
            $keyIndex++
            $dashAndSlashlessName = $mappedParamName -replace '^[-/]{0,}'
            if ($potentialCommand.Parameters[$mappedParamName]) {
                continue
            } else {
                foreach ($potentialParameter in $potentialCommand.Parameters) {
                    if ($potentialParameter.Aliases -contains $mappedParamName) {
                        continue nextParameter
                    }
                }
                $mappedParameters.Insert($keyIndex, $dashAndSlashlessName, $mappedParameters[$mappedParamName])
                $mappedParameters.Remove($mappedParamName)                
            }

        }
    }

    $sentence = 
        [PSCustomObject]@{
            PSTypeName = 'PipeScript.Sentence'
            Keyword    = $commandName
            Command    = $potentialCommand
            Clauses    = $clauses
            Parameters = $mappedParameters
            Arguments  = $unboundParameters
        }

    $sentence                

}
