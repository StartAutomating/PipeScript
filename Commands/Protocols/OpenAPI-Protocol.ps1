
function Protocol.OpenAPI {

    <#
    .SYNOPSIS
        OpenAPI protocol
    .DESCRIPTION
        Converts an OpenAPI to PowerShell.

        This protocol will generate a PowerShell script to communicate with an OpenAPI.
    .EXAMPLE
        # We can easily create a command that talks to a single REST api described in OpenAPI.
        Import-PipeScript {
            function Get-GitHubIssue
            {
                [OpenAPI(SchemaURI=
                    'https://raw.githubusercontent.com/github/rest-api-description/main/descriptions/api.github.com/api.github.com.json#/repos/{owner}/{repo}/issues/get')]    
                param()
            }
        }

        Get-GitHubIssue -Owner StartAutomating -Repo PipeScript
    .EXAMPLE
        # We can also make a general purpose command that talks to every endpoint in a REST api.
        Import-PipeScript {
            function GitHubApi
            {
                [OpenAPI(SchemaURI='https://raw.githubusercontent.com/github/rest-api-description/main/descriptions/api.github.com/api.github.com.json')]
                param()
            }
        }

        GitHubApi '/zen'
    .EXAMPLE
        # We can also use OpenAPI as a command.  Just pass a URL, and get back a script block.
        openapi https://raw.githubusercontent.com/openai/openai-openapi/master/openapi.yaml#/models/get    
    .EXAMPLE
        $TranspiledOpenAPI = { openapi https://raw.githubusercontent.com/openai/openai-openapi/master/openapi.yaml#/models/get } |
            Use-PipeScript
        & $TranspiledOpenAPI # Should -BeOfType ([ScriptBlock])
    #>
    [Alias('OpenAPI','Swagger')]
    [ValidateScript({
        $commandAst = $_

        if ($commandAst -isnot [Management.Automation.Language.CommandAst]) { return $false }
        if ($commandAst.CommandElements.Count -eq 1) { return $false }
        # If neither command element contained a URI
        if (-not ($commandAst.CommandElements[1].Value -match '^https{0,1}://')) {
            return $false
        }
        
        return ($commandAst.CommandElements[0].Value -in 'OpenAPI', 'swagger')
        
    })]
    [CmdletBinding(PositionalBinding=$false)]
    param(
    # The OpenAPI SchemaURI.
    [Parameter(Mandatory,ValueFromPipeline,ParameterSetName='Protocol',Position=0)]
    [Parameter(Mandatory,ValueFromPipeline,ParameterSetName='Interactive',Position=0)]
    [Parameter(Mandatory,ParameterSetName='ScriptBlock')]
    [uri]
    $SchemaUri,

    # The Command's Abstract Syntax Tree.
    # This is provided by PipeScript when transpiling a protocol.
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

    # The name of the parameter used for an access token.
    # By default, this will be 'AccessToken'
    [Alias('Access Token Parameter')]
    [string]
    $AccessTokenParameter,

    # The name of the parameter aliases used for an access token
    [Alias('Access Token Aliases')]
    [string[]]
    $AccessTokenAlias,

    # If set, will not mark a parameter as required, even if the schema indicates it should be.
    [Alias('NoMandatoryParameters','No Mandatory Parameters', 'NoMandatories', 'No Mandatories')]
    [switch]
    $NoMandatory,

    # If provided, will decorate any outputs from the REST api with this typename.
    # If this is not provied, the URL will be used as the typename.
    [Alias('Output Type Name', 'Decorate', 'PSTypeName', 'PsuedoTypeName','Psuedo Type', 'Psuedo Type Name')]
    [string]
    $OutputTypeName
    )

begin {
    # First we declare a few filters we will reuse.

    # One resolves schema definitions.
    # The inputObject is the schema.
    # The arguments are the path within the schema.

    filter resolvePathDefinition {
    
            $in = $_.'paths'
    
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

    filter resolveSchemaDefinition {
    
            $in = $_
            $schemaPath = $args -replace '^#' -replace '^/' -split '[/\.]' -ne ''
            foreach ($sp in $schemaPath) {
                $in = $in.$sp
            }
            $in
        
    }

    filter PropertiesToParameters {
    
            param(
                [ValidateSet('Query','Body','Path')]
                [string]
                $RestParameterType,
        
                [string[]]
                $RequiredParameter
            )
    
            $inObject = $_
            if ($inObject -is [Collections.IDictionary]) {
                $inObject = [PSCustomObject]$inObject
            }
            # Now walk thru each property in the schema
    
            $newPipeScriptParameters = [Ordered]@{}    
            :nextProperty foreach ($property in $inObject.psobject.properties) {
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
                
                $newParameterInfo = [Ordered]@{
                    Name=$parameterName;
                    Attributes=@()
                    Binding = $property.Name
                }
                
                if ($property.value.description) {
                    $newParameterInfo.Description = $property.value.Description
                }
    
                if (-not $NoMandatory -and 
                    (($property.value.required) -or ($RequiredParameter -contains $property.Name))
                ) {
                    $newParameterInfo.Mandatory = $true
                }
    
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
                                $notNullOneOf | 
                                    Sort-Object { if ($_ -is [Collections.IDictionary]) { $_.Count } else { @($_.psobject.properties).length}} -Descending |
                                    Select-Object -First 1
                            }
                        }
                    }
    
                # If there was a single type with an enum
                if ($propertyTypeInfo.enum) {
                                        
                    $validSet = @() + $propertyTypeInfo.enum
                    if ($nullAllowed) {
                        $validSet += ''
                    }
                    $newParameterInfo.ValidValues = $validSet                    
                }
                elseif ($propertyTypeInfo.pattern) 
                {
                    $validPattern = $propertyTypeInfo.pattern
                    if ($nullAllowed) {
                        $validPattern = "(?>^\s{0}$|$validPattern)"
                    }
                    $validPattern = $validPattern.Replace("'", "''")
                    # declare a regex.
                    $newParameterInfo.Attributes += "[ValidatePattern('$validPattern')]"
                }
                elseif ($null -ne $propertyTypeInfo.minimum -and $null -ne $propertyTypeInfo.maximum) {
                    $newParameterInfo.Attributes += "[ValidateRange($($propertyTypeInfo.minimum),$($propertyTypeInfo.maximum))]"
                }
                # If there was a property type            
                if ($propertyTypeInfo.type) { 
                    $newParameterInfo.type = $propertyTypeInfo.type
                }
                # We also create an alias indicating the type of parameter it is.
                $restfulAliasName = switch ($RestParameterType) {
                    'Query' { "?$($property.Name)"  }
                    'Body' {  ".$($property.Name)"  }
                    'Path' {  "/$($property.Name)"  }
                    'Header' { "^$($property.Name)" }
                }
    
                if ($property.Value.default) {
                    $newParameterInfo.Default = $property.Value.default
                } elseif ($propertyTypeInfo.default) {
                    $newParameterInfo.Default = $propertyTypeInfo.default
                }
    
                $newParameterInfo.Alias = $restfulAliasName 
    
                $parameterAttributes += "`$$parameterName"
                
                # $parameterList.insert(0, [Ordered]@{$parameterName=$newParameterInfo})
                $newPipeScriptParameters[$parameterName] = $newParameterInfo            
            }
            $newPipeScriptParameters
        
    }

    # If we have not cached the schema uris, create a collection for it.
    if (-not $script:CachedSchemaUris) {
        $script:CachedSchemaUris = @{}
    }

    $beginForEveryScript = {
        $pathVariable = [Regex]::new('(?<Start>\/)\{(?<Variable>\w+)\}', 'IgnoreCase,IgnorePatternWhitespace')

    
        # Next declare a script block that will replace the rest variable.
        $ReplacePathVariable = {
            param($match)

            if ($restPathParameters -and ($null -ne $restPathParameters[$match.Groups["Variable"].Value])) {
                return $match.Groups["Start"].Value +
                    ([Web.HttpUtility]::UrlEncode(
                        $restPathParameters[$match.Groups["Variable"].Value]
                    ))
            } else {
                return ''
            }
        }
    }

    # Last but not least, we declare a script block with the main contents of a single request
    $ProcessBlockStartForAnEndpoint = {
        # Declare a collection for each type of RESTful parameter.
        $restBodyParameters   = [Ordered]@{}
        $restQueryParameters  = [Ordered]@{}
        $restPathParameters   = [Ordered]@{}
        $restHeaderParameters = [Ordered]@{}
    }

    $processBlockStartForAllEndpoints = {
        $restBodyParameters   = $BodyParameter
        $restQueryParameters  = $QueryParameter
        $restPathParameters   = $PathParameter
        $restHeaderParameters = $HeaderParameter        
    }

    $processForEveryScript = {
        

        # Get my script block
        $myScriptBlock = $MyInvocation.MyCommand.ScriptBlock
        $function:MySelf = $myScriptBlock
        $myCmdInfo = $executionContext.SessionState.InvokeCommand.GetCommand('Myself','Function')        

        # Next, we'll use our own command's metadata to walk thru the parameters.
        
        foreach ($param in ([Management.Automation.CommandMetaData]$myCmdInfo).Parameters.GetEnumerator()) {                        
            # First get the parameter name
            $paramVariableName = $param.Key
            # Everything else we need is in the value.
            $param = $param.Value
            $restParameterType = 'Body'

            # if there are not attributes, this parameter will not be mapped.
            if (-not $param.Attributes) {
                continue
            }

            $specialAlias = @($param.Attributes.AliasNames) -match '^(?<t>[\./\?\^])(?<n>)'
            
            # Not walk over each parameter attribute:
            foreach ($attr in $param.Attributes) {                
                
                # If the attribute is an Alias attribute, see if any of it's names start with a special character.
                # This will indicate how the parameter
                if ($specialAlias) {
                     $restParameterType = 
                         switch ("$specialAlias"[0]) {
                             '/' { 'Path'   }  
                             '?' { 'Query'  }
                             '.' { 'Body'   }
                             '^' { 'Header' }
                         }
                }

                # If the attribute is not a defaultbindingproperty attribute,
                if ($attr -isnot [ComponentModel.DefaultBindingPropertyAttribute]) {
                    continue # keep moving.
                }

                $bindParameterValue = $true
                # Otherwise, update our object with the value
                $propName = $($attr.Name)
                $restParameterDictionary =
                switch ($restParameterType) {
                    Path { $restPathParameters }
                    Query { $restQueryParameters }
                    Header { $restHeaderParameters }
                    default { $restBodyParameters }                    
                }
            }

            # If our bound parameters contains the parameter
            if ($bindParameterValue -and $PSBoundParameters.ContainsKey($paramVariableName)) {
                # use that value
                $restParameterDictionary[$propName] = $PSBoundParameters[$paramVariableName]
                # (don't forget to turn switches into booleans).
                if ($restParameterDictionary[$propName] -is [switch]) {
                    $restParameterDictionary[$propName] = $restParameterDictionary[$propName] -as [bool]
                }
            } else {
                # If we didn't pass a value, but it's a header
                if ($restParameterDictionary -eq $restHeaderParameters) {
                    # check for an environment variable with that name.
                    $environmentVariable = $ExecutionContext.SessionState.PSVariable.Get("env:$paramVariableName").Value
                    # If there is one, use it.
                    if ($environmentVariable) {
                        $restParameterDictionary[$propName] = $environmentVariable
                    }
                }
            }
        }

        if ($PSBoundParameters['Path']) {
            # Replace any variables in the URI
            Write-Verbose "Adding $Path to $BaseUri"
            $uri = "${BaseUri}${Path}"
        }

        # Replace any variables in the URI
        Write-Verbose "Replacing REST Path Parameters in: $uri"
        $replacedUri = $pathVariable.Replace("$Uri", $ReplacePathVariable)
        # If these is no replace URI, return.
        if (-not $replacedUri) { return }
        # Write the replaced URI to verbose
        Write-Verbose "$replacedUri"
        # then add query parameters
        $queryString = if ($restQueryParameters.Count) {
            "?" + (@(
                foreach ($qp in $restQueryParameters.GetEnumerator()) {
                    # Query parameters with multiple values are repeated
                    if ($qp.Value -is [Array]) {
                        foreach ($queryValue in $qp.Value) {
                            "$($qp.Key)=$([Web.HttpUtility]::UrlEncode("$($queryValue)"))"    
                        }
                    } else {
                        "$($qp.Key)=$([Web.HttpUtility]::UrlEncode("$($qp.Value)"))"
                    }
                }
            ) -join '&')
        } else {''}

        # If any were added
        if ($queryString) {
            # append the query string
            $replacedUri += $queryString
            # and write it verbose.
            Write-Verbose "Adding Query String: $queryString"
        }
                
        # Default the method to get, if one has not been provided
        if (-not $Method) { $Method = 'get' }

        # Create a cache for authorization headers, if one does not exist
        if (-not $script:CachedAuthorizationHeaders) {
            $script:CachedAuthorizationHeaders = @{}
        }

        if ($restHeaderParameters.Count) {
            foreach ($kv in @($restHeaderParameters.GetEnumerator())) {
                if ($kv.Key -notlike '*:*') { continue }
                $headerName, $headerPrefix = $kv.Key -split ':', 2
                $restHeaderParameters[$headerName] = "$headerPrefix $($kv.Value)"
                # If the header was 'Authorization'
                if ($headerName -eq 'Authorization') {
                    # cache the value for this BaseURI
                    $script:CachedAuthorizationHeaders["$BaseUri"] = $restHeaderParameters[$headerName]
                }
                $restHeaderParameters.Remove($kv.Key)                
            }
        }

        # If we have a cached authorization header and didn't provide one, use it.
        if ($script:CachedAuthorizationHeaders["$BaseUri"] -and -not $restHeaderParameters['Authorization']) {            
            $restHeaderParameters['Authorization'] = $script:CachedAuthorizationHeaders["$BaseUri"]
        }

        $invokeSplat = @{
            Uri = $replacedUri
            Method = $method
            Headers = $restHeaderParameters
        }
        if ($restBodyParameters.Count) {
            $requestBody = ConvertTo-Json $restBodyParameters -Depth 100
            $invokeSplat.ContentType = 'application/json'
            $invokeSplat.Body = $requestBody
        }

        if (-not $OutputTypeName) {
            $OutputTypeName = "$uri"
        }
        
        $restfulOutput = Invoke-RestMethod @invokeSplat
        foreach ($restOut in $restfulOutput) {
            if ($restOut -isnot [Byte] -and 
                $restOut -isnot [Byte[]] -and 
                $restOut.pstypenames) {
                if ($restOut.pstypenames -notcontains $OutputTypeName) {
                    $restOut.pstypenames.insert(0, $OutputTypeName)
                }
                $restOut
            } else {
                $restOut
            }
        }
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
        
    if ($schemaObject -is [string] -and $SchemaUri -like '*y*ml*') {
        $requirePSYaml = Invoke-PipeScript {     
                                             $ImportedRequirements = foreach ($moduleRequirement in 'powershell-yaml') {
                                                 $requireLatest = $false
                                                 $ModuleLoader  = $null
                                             
                                                 # If the module requirement was a string
                                                 if ($moduleRequirement -is [string]) {
                                                     # see if it's already loaded
                                                     $foundModuleRequirement = Get-Module $moduleRequirement
                                                     if (-not $foundModuleRequirement) {
                                                         # If it wasn't,
                                                         $foundModuleRequirement = try { # try loading it
                                                             Import-Module -Name $moduleRequirement -PassThru -Global -ErrorAction 'Ignore'
                                                         } catch {                
                                                             $null
                                                         }
                                                     }
                                             
                                                     # If we found a version but require the latest version,
                                                     if ($foundModuleRequirement -and $requireLatest) {
                                                         # then find if there is a more recent version.
                                                         Write-Verbose "Searching for a more recent version of $($foundModuleRequirement.Name)@$($foundModuleRequirement.Version)"
                                             
                                                         if (-not $script:FoundModuleVersions) {
                                                             $script:FoundModuleVersions = @{}
                                                         }
                                             
                                                         if (-not $script:FoundModuleVersions[$foundModuleRequirement.Name]) {
                                                             $script:FoundModuleVersions[$foundModuleRequirement.Name] = Find-Module -Name $foundModuleRequirement.Name            
                                                         }
                                                         $foundModuleInGallery = $script:FoundModuleVersions[$foundModuleRequirement.Name]
                                                         if ($foundModuleInGallery -and 
                                                             ([Version]$foundModuleInGallery.Version -gt [Version]$foundModuleRequirement.Version)) {
                                                             Write-Verbose "$($foundModuleInGallery.Name)@$($foundModuleInGallery.Version)"
                                                             # If there was a more recent version, unload the one we already have
                                                             $foundModuleRequirement | Remove-Module # Unload the existing module
                                                             $foundModuleRequirement = $null
                                                         } else {
                                                             Write-Verbose "$($foundModuleRequirement.Name)@$($foundModuleRequirement.Version) is the latest"
                                                         }
                                                     }
                                             
                                                     # If we have no found the required module at this point
                                                     if (-not $foundModuleRequirement) {
                                                         if ($moduleLoader) { # load it using a -ModuleLoader (if provided)
                                                             $foundModuleRequirement = . $moduleLoader $moduleRequirement
                                                         } else {
                                                             # or install it from the gallery.
                                                             Install-Module -Name $moduleRequirement -Scope CurrentUser -Force -AllowClobber
                                                             if ($?) {
                                                                 # Provided the installation worked, try importing it
                                                                 $foundModuleRequirement =
                                                                     Import-Module -Name $moduleRequirement -PassThru -Global -ErrorAction 'Continue' -Force
                                                             }
                                                         }
                                                     } else {
                                                         $foundModuleRequirement
                                                     }
                                                 }
                                             } }
        $schemaObject  = $schemaObject | ConvertFrom-Yaml -Ordered
    }

    # If we do not have a schema object, error out.
    if (-not $schemaObject) {
        Write-Error "Could not get Schema from '$schemaUri'"
        return
    }

    # If the object does not have .paths, it's not an OpenAPI schema, error out.
    if (-not $schemaObject.paths) {
        Write-Error "'$schemaUri' does not have .paths"
        return
    }
    
    # Resolve the schema paths(s) we want to generate.
    $UrlRelativePath = ''
    $RestMethod      = 'get'

    $schemaDefinition = 
        if ($SchemaUri.Fragment) {
            $pathFragment = [Web.HttpUtility]::UrlDecode($SchemaUri.Fragment -replace '^\#')
            $methodFragment = @($SchemaUri.Fragment -split '/')[-1]
            if ($schemaObject.paths.$pathFragment) {
                $schemaObject.paths.$pathFragment
                $UrlRelativePath = $pathFragment
            }
            elseif ($(
                $pathAndMethod = 
                    $schemaObject.paths.(
                        $pathFragment -replace "/$MethodFragment$"
                    ).$methodFragment
                $pathAndMethod
            )) {
                $UrlRelativePath = ($pathFragment -replace "/$MethodFragment$")
                $RestMethod  = $methodFragment
                $pathAndMethod
            }
            elseif ($(
                $resolvedSchemaFragment = $schemaObject | resolveSchemaDefinition $SchemaUri.Fragment
                $resolvedSchemaFragment
            )) {
                $resolvedSchemaFragment                
            } 
            else {
                Write-Error "Could not resolve $($schemaUri.Fragment) within $($schemaUri)"
                return
            }           
        } else {
            $null
        }

    
    

    # Start off by carrying over the summary.
    $newPipeScriptSplat = @{
        Synopsis = $schemaDefinition.summary
    }

    if ($schemaDefinition.properties -is [Collections.IDictionary]) {
        $schemaDefinition.properties = [PSCustomObject]$schemaDefinition.properties
    }

    $parametersFromProperties = $schemaDefinition.properties | PropertiesToParameters
    # Now walk thru each property in the schema
    $newPipeScriptParameters = [Ordered]@{} + $parametersFromProperties

    if ($schemaDefinition.parameters) {        
        foreach ($pathOrQueryParameter in $schemaDefinition.parameters) {
            if ($pathOrQueryParameter.'$ref') {
                $pathOrQueryParameter = $schemaObject | resolveSchemaDefinition $pathOrQueryParameter.'$ref'
            }
            if (-not $pathOrQueryParameter.Name) { continue }
            
            $newPipeScriptParameters[$pathOrQueryParameter.Name] = @{
                Name = $pathOrQueryParameter.Name | getSchemaParameterName
                Description = $pathOrQueryParameter.description
                Attribute = if ($pathOrQueryParameter.required) { "Mandatory"} else { ''}
                Type = $pathOrQueryParameter.schema.type
                Alias = "$(
                    switch ($pathOrQueryParameter.in) { Path {'/'} Query {'?'} Header {'^'} default {'.'}}
                )$($pathOrQueryParameter.Name)"
                Binding = "$($pathOrQueryParameter.Name)"
            }
            
        }        
        if ($schemaDefinition.parameters -is [Collections.IDictionary]) {
            $schemaDefinition.parameters = [PSCustomObject]$schemaDefinition.parameters
        }
    }
    

    if ($schemaDefinition.requestBody) {
        $bodySchema = $schemaDefinition.requestBody.content.'application/json'.schema        
        $parametersFromBody = 
            if ($bodySchema.'$ref') {
                $resolvedRef = $schemaObject | resolveSchemaDefinition $bodySchema.'$ref'
                $resolvedRef.properties |
                    PropertiesToParameters -RestParameterType Body -RequiredParameter $resolvedRef.required
            } elseif ($bodySchema.properties) {                
                $bodySchema.properties | PropertiesToParameters -RestParameterType Body
            } else {
                @{}
            }
        try {
            $newPipeScriptParameters += $parametersFromBody
        } catch {
            foreach ($kv in $newPipeScriptParameters.GetEnumerator()) {
                if ($newPipeScriptParameters[$kv.Key]) {
                    # Conflict between body and query.  IMHO this is bad api design on their part.
                    $null = $null
                } else {
                    $newPipeScriptParameters[$kv.Key] = $kv.Value
                }
            }
        }
    }


    # If we did not have a specific Schema Defined by the path.
    if (-not $SchemaDefinition) {
        if ($schemaObject.paths -is [Collections.IDictionary]) {
            $schemaObject.paths = [PSCustomObject]$schemaObject.paths
        }

        $validPaths = @(
            foreach ($pathProperty in $schemaObject.paths.psobject.properties) {
                $pathProperty.name
            }
        )

        # we will make a generic command that can invoke any path.
        $newPipeScriptParameters['Path'] = [Ordered]@{
            Name = 'Path'
            Aliases = 'RelativePath'           
            Help = 'The relative path of the RESTful endpoint'
            Attributes = 'ValueFromPipelineByPropertyName'
            Type = [string[]]
            ValidValues = $validPaths
        }

        $newPipeScriptParameters['BodyParameter'] = [Ordered]@{
            Aliases = 'BodyParameters', 'Body'
            Help = 'Parameters passed in the body of the request'
            Attributes = 'ValueFromPipelineByPropertyName'
            Type = [Collections.IDictionary]
            DefaultValue = {[Ordered]@{}}
        }

        $newPipeScriptParameters['QueryParameter'] = [Ordered]@{
            Aliases = 'QueryParameters', 'Query'
            Help = 'Parameters passed in the query string of the request'
            Attributes = 'ValueFromPipelineByPropertyName'
            Type = [Collections.IDictionary]
            DefaultValue = {[Ordered]@{}}
        }

        $newPipeScriptParameters['PathParameter'] = [Ordered]@{
            Aliases = 'PathParameters'
            Help = 'Parameters passed in the path of the request'
            Attributes = 'ValueFromPipelineByPropertyName'
            Type = [Collections.IDictionary]
            DefaultValue = {[Ordered]@{}}
        }

        $newPipeScriptParameters['HeaderParameter'] = [Ordered]@{
            Aliases = 'HeaderParameters', 'Header','Headers'
            Help = 'Parameters passed in the headers of the request'
            Attributes = 'ValueFromPipelineByPropertyName'
            Type = [Collections.IDictionary]
            DefaultValue = {[Ordered]@{}}
        }                

        $newPipeScriptParameters['Method'] = [Ordered]@{
            Name = 'Method'
            Aliases = 'HTTPMethod'           
            Help = 'The HTTP Method used for the request'
            Attributes = 'ValueFromPipelineByPropertyName'
            Type = [string]
        }
    }

    if (-not $AccessTokenParameter) {
        $AccessTokenParameter = 'AccessToken'
    }

    if (-not $newPipeScriptParameters[$AccessTokenParameter]) {
        if (-not $AccessTokenAlias) {
            $AccessTokenAlias = 'PersonalAccessToken', 'BearerToken', '^Bearer'
        } elseif ($AccessTokenAlias -notlike '^*') {
            $AccessTokenAlias += '^Bearer'
        }
        $newPipeScriptParameters[$AccessTokenParameter] = @{
            Aliases = 'PersonalAccessToken', 'BearerToken', '^Bearer'
            Binding = 'Authorization:Bearer'
            Type    = 'string'
            Description = 'The Access Token used for the request.'
        }
    }
    $newPipeScriptSplat.Parameter = $newPipeScriptParameters

    
    # If there was no scriptblock, or it was nothing but an empty param()
    if ($ScriptBlock -match '^[\s\r\n]{0,}(?:param\(\))?[\s\r\n]{0,}$') {
        $absoluteUri = "$($schemaObject.servers.url)"
        $newPipeScriptSplat.Begin = 
        [ScriptBlock]::create(
            @(
                "`$Method, `$Uri, `$outputTypeName = '$($RestMethod)', '${absoluteUri}${UrlRelativePath}', '$OutputTypeName'"
                "`$BaseUri = `$Uri"
                $beginForEveryScript
            ) -join [Environment]::NewLine
        )
        if ($schemaDefinition) {
            $newPipeScriptSplat.Process = [ScriptBlock]::Create(
                @(
                    $ProcessBlockStartForAnEndpoint
                    $processForEveryScript
                ) -join [Environment]::NewLine
            )
        } else {
            
            $newPipeScriptSplat.Process = [ScriptBlock]::Create(
                @(
                    $ProcessBlockStartForAllEndpoints
                    $processForEveryScript
                ) -join [Environment]::NewLine
            )            
        }
        
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

