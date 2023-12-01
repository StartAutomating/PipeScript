
function Protocol.JSONSchema {

    <#
    .SYNOPSIS
        JSON Schema protocol
    .DESCRIPTION
        Converts a JSON Schema to a PowerShell Script.
    .EXAMPLE
        jsonschema https://aka.ms/terminal-profiles-schema#/$defs/Profile
    .EXAMPLE
        {
            [JSONSchema(SchemaURI='https://aka.ms/terminal-profiles-schema#/$defs/Profile')]
            param()
        }.Transpile()
    #>
    [ValidateScript({
        $commandAst = $_

        if ($commandAst -isnot [Management.Automation.Language.CommandAst]) { return $false }
        if ($commandAst.CommandElements.Count -eq 1) { return $false }
        # If neither command element contained a URI
        if (-not ($commandAst.CommandElements[1].Value -match '^https{0,1}://')) {
            return $false
        }
        
        return ($commandAst.CommandElements[0].Value -in 'schema', 'jsonschema')    
    })]
    [Alias('JSONSchema')]
    param(
    # The JSON Schema URI.
    [Parameter(Mandatory,ValueFromPipeline,ParameterSetName='Protocol',Position=0)]
    [Parameter(Mandatory,ValueFromPipeline,ParameterSetName='Interactive',Position=0)]
    [Parameter(Mandatory,ParameterSetName='ScriptBlock')]
    [uri]
    $SchemaUri,

    # The Command's Abstract Syntax Tree
    [Parameter(Mandatory,ParameterSetName='Protocol')]
    [Management.Automation.Language.CommandAST]
    $CommandAst,

    # The ScriptBlock.
    # This is provided when transpiling the protocol as an attribute.
    # Providing a value here will run this script's contents, rather than a default implementation.
    [Parameter(Mandatory,ParameterSetName='ScriptBlock',ValueFromPipeline)]
    [scriptblock]
    $ScriptBlock = {},

    # One or more property prefixes to remove.
    # Properties that start with this prefix will become parameters without the prefix.
    [Alias('Remove Property Prefix')]
    [string[]]
    $RemovePropertyPrefix,

    # One or more properties to ignore.
    # Properties whose name or description is like this keyword will be ignored.
    [Alias('Ignore Property', 'IgnoreProperty','SkipProperty', 'Skip Property')]
    [string[]]
    $ExcludeProperty,

    # One or more properties to include.
    # Properties whose name or description is like this keyword will be included.
    [Alias('Include Property')]
    [string[]]
    $IncludeProperty,

    # If set, will not mark a parameter as required, even if the schema indicates it should be.
    [Alias('NoMandatoryParameters','No Mandatory Parameters', 'NoMandatories', 'No Mandatories')]
    [switch]
    $NoMandatory
    )

    begin {
        # First we declare a few filters we will reuse.

        # One resolves schema definitions.
        # The inputObject is the schema.
        # The arguments are the path within the schema.
        filter resolveSchemaDefinition
        {
            $in = $_.'$defs'
            $schemaPath = $args -replace '^#' -replace '^/' -replace '^\$defs' -split '[/\.]' -ne ''
            foreach ($sp in $schemaPath) {
                $in = $in.$sp
            }
            $in
        }

        # Another converts property names into schema parameter names.
        filter getSchemaParameterName {
            $parameterName = $_
            # If we had any prefixes we wished to remove, now is the time.
            if ($RemovePropertyPrefix) {            
                $parameterName = $parameterName -replace "^(?>$(@($RemovePropertyPrefix) -join '|'))"
                if ($property.Name -like 'Experimental.*') {
                    $null = $null
                }                                
            }
            # Any punctuation followed by a letter should be removed and replaced with an Uppercase letter.
            $parameterName = [regex]::Replace($parameterName, "\p{P}(\p{L})", {
                param($match)
                $match.Groups[1].Value.ToUpper()
            }) -replace '\p{P}'
            # And we should force the first letter to be uppercase.
            $parameterName.Substring(0,1).ToUpper() + $parameterName.Substring(1)
        }

        # If we have not cached the schema uris, create a collection for it.
        if (-not $script:CachedSchemaUris) {
            $script:CachedSchemaUris = @{}
        }


        $myCmd = $MyInvocation.MyCommand
        
    }

    process {
        # If we are being invoked as a protocol
        if ($PSCmdlet.ParameterSetName -eq 'Protocol') {
            # we will parse our input as a sentence.
            $mySentence = $commandAst.AsSentence($MyInvocation.MyCommand)
            # Walk thru all mapped parameters in the sentence
            $myParams = [Ordered]@{} + $PSBoundParameters
            foreach ($paramName in $mySentence.Parameters.Keys) {
                if (-not $myParams.Contains($paramName)) { # If the parameter was not directly supplied
                    $myParams[$paramName] = $mySentence.Parameters[$paramName] # grab it from the sentence.
                    foreach ($myParam in $myCmd.Parameters.Values) {
                        if ($myParam.Aliases -contains $paramName) { # set any variables that share the name of an alias
                            $ExecutionContext.SessionState.PSVariable.Set($myParam.Name, $mySentence.Parameters[$paramName])
                        }
                    }
                    # and set this variable for this value.
                    $ExecutionContext.SessionState.PSVariable.Set($paramName, $mySentence.Parameters[$paramName])
                }
            }        
        }

        if (-not $SchemaUri.Scheme) {
            $SchemaUri = [uri]"https://$($SchemaUri.OriginalString -replace '://')"
        }

        # We will try to cache the schema URI at a given scope.
        $script:CachedSchemaUris[$SchemaUri] = $schemaObject = 
            if (-not $script:CachedSchemaUris[$SchemaUri]) {
                Invoke-RestMethod -Uri $SchemaUri
            } else {
                $script:CachedSchemaUris[$SchemaUri]
            }    

        # If we do not have a schema object, error out.
        if (-not $schemaObject) {
            Write-Error "Could not get Schema from '$schemaUri'"
            return
        }

        # If the object does not look have a JSON schema, error out.
        if (-not $schemaObject.'$schema') {
            Write-Error "'$schemaUri' is not a JSON Schema"
            return
        }

        # If we do not have a URI fragment or there are no properties
        if (-not $SchemaUri.Fragment -and -not $schemaObject.properties) {        
            Write-Error "No root properties defined and no definition specified"
            return # error out.
        }

        # Resolve the schema object we want to generate.
        $schemaDefinition = 
            if (-not $schemaObject.properties -and $SchemaUri.Fragment) {
                $schemaObject | resolveSchemaDefinition $SchemaUri.Fragment            
            } else {
                $schemaObject.properties
            }

        # Start off by carrying over the description.
        $newPipeScriptSplat = @{
            description = $schemaDefinition.description                
        }

        # Now walk thru each property in the schema
        $newPipeScriptParameters = [Ordered]@{}
        :nextProperty foreach ($property in $schemaDefinition.properties.psobject.properties) {
            # Filter out excluded properties
            if ($ExcludeProperty) {
                foreach ($exc in $ExcludeProperty) {
                    if ($property.Name -like $exc) { 
                        continue nextProperty
                    }
                }
            }
            # Filter included properties
            if ($IncludeProperty) {
                $included = foreach ($inc in $IncludeProperty) {
                    if ($property.Name -like $inc) {
                        $true;break
                    }
                }
                if (-not $included) { continue nextProperty }
            }
            
            # Convert the property into a parameter name
            $parameterName = $property.Name | getSchemaParameterName
            
            # Collect the parameter attributes
            $parameterAttributes = @(
                # The description comes first, as inline help
                $propertyDescription = $property.value.description
                if ($propertyDescription -match '\n') {
                    "    <#"
                    "    " + $($propertyDescription -split '(?>\r\n|\n)' -join ([Environment]::NewLine + (' ' * 4))
                    )                
                    "    #>"
                } else {
                    "# $propertyDescription"
                }
                "[Parameter($(
                    if ($property.value.required -and -not $NoMandatory) { "Mandatory,"}
                )ValueFromPipelineByPropertyName)]"

                # Followed by the defaultBindingProperty (the name of the JSON property)
                "[ComponentModel.DefaultBindingProperty('$($property.Name)')]"

                # Keep track of if null was allowed and try to resolve the type
                $nullAllowed = $false
                $propertyTypeInfo =                 
                    if ($property.value.'$ref') {
                        # If there was a reference, try to resolve it
                        $referencedType = $schemaObject | resolveSchemaDefinition $property.value.'$ref'
                        if ($referencedType) {
                            $referencedType
                        }
                    } else {
                        # If there is not a oneOf, return the value
                        if (-not $property.value.'oneOf') {
                            $property.value
                        } else {
                            # If there is oneOf, see if it's an optional null
                            $notNullOneOf = 
                                @(foreach ($oneOf in $property.value.oneOf) {
                                    if ($oneOf.type -eq 'null') { 
                                        $nullAllowed = $true
                                        continue                                    
                                    }
                                    $oneOf
                                })
                            if ($notNullOneOf.Count -eq 1) {
                                $notNullOneOf = $notNullOneOf[0]
                                if ($notNullOneOf.'$ref') {
                                    $referencedType = $schemaObject | resolveSchemaDefinition $notNullOneOf.'$ref'
                                    if ($referencedType) {
                                        $referencedType
                                    }
                                } else {
                                    $notNullOneOf
                                }
                            } else {
                                "[PSObject]"
                            }
                        }
                    }
                
                
                # If there was a single type with an enum
                if ($propertyTypeInfo.enum) {
                    $validSet = @() + $propertyTypeInfo.enum
                    if ($nullAllowed) {
                        $validSet += ''
                    }

                    # create a validateset.
                    "[ValidateSet('$($validSet -join "','")')]"
                }
                # If there was a validation pattern
                elseif ($propertyTypeInfo.pattern) 
                {
                    $validPattern = $propertyTypeInfo.pattern
                    if ($nullAllowed) {
                        $validPattern = "(?>^\s{0}$|$validPattern)"
                    }
                    $validPattern = $validPattern.Replace("'", "''")
                    # declare a regex.
                    "[ValidatePattern('$validPattern')]"
                }
                # If there was a property type            
                if ($propertyTypeInfo.type) { 
                    # limit the input               
                    switch ($propertyTypeInfo.type) {
                        "string" {
                            "[string]"
                        }
                        "integer" {
                            "[int]"
                        }
                        "number" {
                            "[double]"
                        }
                        "boolean" {
                            "[switch]"
                        }
                        "array" {
                            "[PSObject[]]"
                        }
                        "object" {
                            "[PSObject]"
                        }
                    }
                }
            )

            $parameterAttributes += "`$$parameterName"
            $newPipeScriptParameters[$parameterName] = $parameterAttributes        
        }


        $newPipeScriptSplat.Parameter = $newPipeScriptParameters
        
        # If there was no scriptblock, or it was nothing but an empty param()
        if ($ScriptBlock -match '^[\s\r\n]{0,}(?:param\([\s\r\n]{0,}\))[\s\r\n]{0,}$') {
            # Create a script that will create the schema object.
            $newPipeScriptSplat.Process = [scriptblock]::Create("
        `$schemaTypeName = '$("$schemauri".Replace("'","''"))'
    " + {
        
        # Get my script block
        $myScriptBlock = $MyInvocation.MyCommand.ScriptBlock
        # and declare an output object.
        $myParamCopy = [Ordered]@{PSTypeName=$schemaTypeName}
        # Walk over each parameter in my own AST.
        foreach ($param in $myScriptBlock.Ast.ParamBlock.Parameters) {
            # if there are not attributes, this parameter will not be mapped.
            if (-not $param.Attributes) {
                continue
            }
            # If the parameter was not passed, this parameter will not be mapped.
            $paramVariableName = $param.Name.VariablePath.ToString()
            if (-not $PSBoundParameters.ContainsKey($paramVariableName)) {
                continue
            }
            # Not walk over each attribute
            foreach ($attr in $param.Attributes) {
                # If the attribute is not a defaultbindingproperty attribute,
                if ($attr.TypeName.GetReflectionType() -ne [ComponentModel.DefaultBindingPropertyAttribute]) {
                    continue # keep moving.
                }
                # Otherwise, update our object with the value
                $propName = $($attr.PositionalArguments.value)
                $myParamCopy[$propName] = $PSBoundParameters[$paramVariableName]
                # (don't forget to turn switches into booleans)
                if ($myParamCopy[$propName] -is [switch]) {
                    $myParamCopy[$propName] = $myParamCopy[$propName] -as [bool]
                }
            
            }
        }

        # By converting our modified copy of parameters into an object
        # we should have an object that matches the schema.
        [PSCustomObject]$myParamCopy
    })
        }

        # If we are transpiling a script block
        if ($PSCmdlet.ParameterSetName -eq 'ScriptBlock') {
            # join the existing script with the schema information
            Join-PipeScript -ScriptBlock $ScriptBlock, (
                New-PipeScript @newPipeScriptSplat
            )            
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'Protocol') 
        {
            # Otherwise, create a script block that produces the schema.
            [ScriptBlock]::create("{
    $(New-PipeScript @newPipeScriptSplat)
    }")
        } else {
            New-PipeScript @newPipeScriptSplat
        }    
    }

}

