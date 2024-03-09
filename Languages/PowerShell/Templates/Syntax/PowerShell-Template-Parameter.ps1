[ValidatePattern("(?>PowerShell|PipeScript)")]
param()


function Template.PowerShell.Parameter {

    <#
    .SYNOPSIS
        PowerShell Parameter Template
    .DESCRIPTION
        Generates a parameter declaration for a PowerShell function.
    .EXAMPLE
        Template.PowerShell.Parameter -Name "MyParameter" -Type "string" -DefaultValue "MyDefaultValue" -Description "My Description"
    #>
    [Alias('Template.PipeScript.Parameter')]
    param(
    # The name of the parameter.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ParameterName')]
    [psobject]
    $Name,

    # Any parameter attributes.
    # These will appear first.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ParameterAttributes')]
    [psobject[]]
    $ParameterAttribute,

    # Any parameter aliases
    # These will appear beneath parameter attributes.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Aliases','AliasName','AliasNames')]
    [psobject[]]
    $Alias,

    # Any other attributes.  These will appear directly above the type and name.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Attributes')]
    [psobject[]]
    $Attribute,

    # One or more parameter types.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ParameterType','ParameterTypes')]
    [psobject[]]
    $Type,

    # One or more default values (if more than one default value is provided, it will be assumed to be an array)
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Default','ParameterDefault','ParameterDefaultValue')]
    [psobject]
    $DefaultValue,

    # A valid set of values    
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ValidValue','ValidValues')]
    [psobject[]]
    $ValidateSet,

    # The Parameter description (any help for the parameter)
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Help','ParameterHelp','Synopsis','Summary')]
    [psobject[]]
    $Description,

    # Any simple bindings for the parameter.
    # These are often used to describe the name of a parameter in an underlying system.
    # For example, a parameter might be named "Name" in PowerShell, but "itemName" in JSON.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Bindings','DefaultBinding','DefaultBindingProperty')]
    [string[]]
    $Binding,
    
    # The ambient value
    # This script block can be used to coerce a value into the desired real value.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('CoerceValue')]
    [scriptblock]
    $AmbientValue,

    # Any additional parameter metadata.
    # Any dictionaries passed to this parameter will be converted to [Reflection.AssemblyMetadata] attributes.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ReflectionMetadata','ParameterMetadata')]
    [psobject[]]
    $Metadata,

    # The validation pattern for the parameter.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Pattern','Regex')]
    [psobject[]]
    $ValidatePattern,

    # If set, will make the parameter more weakly typed.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $WeaklyTyped,

    # If set, will attempt to avoid creating mandatory parameters.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $NoMandatory
    )
    
    begin {

        $generatedParameters = [Collections.Queue]::new()
        filter embedParameterHelp {
        
                    if ($_ -notmatch '^\s\<\#' -and $_ -notmatch '^\s\#') {
                        $commentLines = @($_ -split '(?>\r\n|\n)')
                        if ($commentLines.Count -gt 1) {
                            '<#' + [Environment]::NewLine + "$_".Trim() + [Environment]::newLine + '#>'
                        } else {
                            "# $_"
                        }
                    } else {
                        $_
                    }
                
        }

        filter PseudoTypeToRealType {
        
                    switch ($_) {
                        string { [string] }
                        integer { [int] }
                        number { [double]}
                        boolean { [switch] }
                        array { [PSObject[]] }
                        object { [PSObject] }
                        default {
                            if ($_ -as [type]) {
                                $_ -as [type]
                            }                    
                        }
                    }
                
        }
    }

    process {
        # Presort the attributes
        $attribute = @(foreach ($attr in $Attribute) {            
            switch ($attr) {
            {$_ -is [ValidateSet]}
            {
                                $ValidateSet += $attr.ValidValues
                                continue
                            }
            {$_ -is [Management.Automation.ParameterAttribute]}
            {
                                $ParameterAttribute += $attr
                                continue
                            }
            {$_ -is [Management.Automation.AliasAttribute]}
            {
                                $Alias += $attr
                                continue
                            }
            default {
                                $attr
                            }
            }
        })

        $parameterAttribute = foreach ($paramAttr in $ParameterAttribute) {
            switch ($paramAttr) {
            {$_ -is [Management.Automation.AliasAttribute]}
            {
                                $Alias += $paramAttr
                            }
            {$_ -is [Management.Automation.ParameterAttribute]}
            {
                                $paramAttr
                            }
            {$_ -is [Attribute]}
            {
                                $Attribute += $paramAttr
                            }
            default {
                                $paramAttr
                            }
            }
        }    

        
        $parameterName = $name

        $attrs = @($ParameterAttribute;$attribute)

        $parameterAliases = @(
            foreach ($aka in $alias) {
                if ($aka -is [Management.Automation.AliasAttribute]) {
                    $aka.AliasNames
                } elseif ($aka -is [string]) {
                    $aka
                }
            }
        )
                                            
        $parameterAttributeParts = @()
        $ParameterOtherAttributes = @()
        # Aliases can be in .Alias/.Aliases

        [string[]]$aliases = $parameterAliases

        # Help can be in .Help/.Description/.Synopsis/.Summary
        [string]$parameterHelpText = $Description -join ([Environment]::NewLine)                            

        # Metadata can be in .Metadata/.ReflectionMetadata/.ParameterMetadata
        $parameterMetadataProperties = $Metadata

        # Valid Values can be found in .ValidValue/.ValidValues/.ValidateSet
        $parameterValidValues = $ValidateSet

        $parameterValidPattern = $ValidatePattern

        # Default values can be found in .DefaultValue/.Default
        $parameterDefaultValue = $DefaultValue
        
        $aliasAttribute = @(foreach ($aka in $aliases) {
            $aka -replace "'","''"                            
        }) -join "','"
        if ($aliasAttribute) {
            $aliasAttribute = "[Alias('$aliasAttribute')]"
        }

        if ($parameterValidValues) {
            $attrs += "[ValidateSet('$($parameterValidValues -replace "'","''" -join "','")')]"    
        }

        if ($parameterValidPattern) {
            $attrs += "[ValidatePattern('$($parameterValidPattern -replace "'","''")')]"    
        }

        if ($Binding) {
            foreach ($bindingProperty in $Binding) {
                $attrs += "[ComponentModel.DefaultBindingProperty('$bindingProperty')]"
            }
        }
        
        if ($parameterMetadataProperties) {
            foreach ($pmdProp in $parameterMetadataProperties) {
                if ($pmdProp -is [Collections.IDictionary]) {
                    foreach ($mdKv in $pmdProp.GetEnumerator()) {
                        $attrs += "[Reflection.AssemblyMetadata('$($mdKv.Key)', '$($mdKv.Value -replace "',''")')]"
                    }
                }
            }
        }

        if ($AmbientValue) {
            foreach ($ambient in $AmbientValue) {                
                $attrs += "[ComponentModel.AmbientValue({$ambient})]"
            }
        }
 
        $alreadyIncludedAttributes = @()
        foreach ($attr in $attrs) {
            if ($attr -is [Attribute]) {
                $attrType = $attr.GetType()
                if ($alreadyIncludedAttributes -contains $attr) { continue }
                if ($attr -is [Parameter]) {
                    $ParameterOtherAttributes += "[Parameter($(@(
                        if ($attr.Mandatory) { 'Mandatory' }
                        if ($attr.Postition -ge 0) { "Position=$($attr.Position)"}
                        if ($attr.ParameterSetName -and $attr.ParameterSetName -ne '__AllParameterSets') {
                            "ParameterSetName='$($attr.ParameterSetName -replace "'","''")'"
                        }
                        if ($attr.ValueFromPipeline) { 'ValueFromPipeline' }
                        if ($attr.ValueFromPipelineByPropertyName) { 'ValueFromPipelineByPropertyName' }
                        if ($attr.ValueFromRemainingArguments) { 'ValueFromRemainingArguments' }
                        if ($attr.DontShow) { 'DontShow' }
                    ) -join ','))]"
                } else {
                    $attr | Template.PowerShell.Attribute
                }
                $alreadyIncludedAttributes += $attr
                continue
            }
            if ($attr -notmatch '^\[') {
                $parameterAttributeParts += $attr
            } else {
                $ParameterOtherAttributes += $attr
            }
        }

        if (
            ($parameterMetadata.Mandatory -or $parameterMetadata.required) -and 
            ($parameterAttributeParts -notmatch 'Mandatory') -and 
            -not $NoMandatory) {
            $parameterAttributeParts = @('Mandatory') + $parameterAttributeParts
        }

        $parameterType = $Type
        
        $parameterDeclaration = @(
            if ($ParameterHelpText) {
                $ParameterHelpText | embedParameterHelp
            }
            if ($parameterAttributeParts) {
                "[Parameter($($parameterAttributeParts -join ','))]"
            }
            if ($aliasAttribute) {
                $aliasAttribute
            }
            if ($ParameterOtherAttributes) {
                $ParameterOtherAttributes
            }
            $PseudoType = $parameterType | PseudoTypeToRealType
            if ($PseudoType) {
                $parameterType = $PseudoType                                    
                if ($parameterType -eq [bool]) {
                    "[switch]"
                } 
                elseif ($parameterType -eq [array]) {
                    "[PSObject[]]"
                }
                else {
                    if ($WeaklyTyped) {
                        if ($parameterType.GetInterface -and 
                            $parameterType.GetInterface([Collections.IDictionary])) {
                            "[Collections.IDictionary]"
                        }                                            
                        elseif ($parameterType.GetInterface -and 
                            $parameterType.GetInterface([Collections.IList])) {
                            "[PSObject[]]"
                        }
                        else {
                            "[PSObject]"
                        }
                    } else {
                        if ($parameterType.IsGenericType -and
                            $parameterType.GetInterface -and 
                            $parameterType.GetInterface(([Collections.IList])) -and
                            $parameterType.GenericTypeArguments.Count -eq 1
                        ) {
                            "[$($parameterType.GenericTypeArguments[0].Fullname -replace '^System\.')[]]"
                        } else {
                            "[$($parameterType.FullName -replace '^System\.')]"
                        }
                        
                    }
                }                                    
            }
            elseif ($parameterType) {
                "[PSTypeName('$($parameterType -replace '^System\.')')]"                                                                        
            }

            $DefaultValueSection = if ($parameterDefaultValue) {                                        
                if ($parameterDefaultValue -is [scriptblock]) {
                    if ($parameterType -eq [scriptblock]) {
                        "= {$ParameterDefaultValue}"
                    } else {
                        "= `$($ParameterDefaultValue)"
                    }                                            
                } elseif ($parameterDefaultValue -is [string]) {
                    "= `$('$($parameterDefaultValue -replace "'","''")')"
                } elseif ($parameterDefaultValue -is [bool] -or $parameterDefaultValue -is [switch]) {
                    "= `$$($parameterDefaultValue -as [bool])"
                }
            } else { '' }
                                            
            '$' + ($parameterName -replace '^$') + $DefaultValueSection
        ) -join [Environment]::newLine
   


        $generatedParameters.Enqueue($parameterDeclaration)
    }

    end {
        $generatedParameters.ToArray() -join (',' + [Environment]::newLine + [Environment]::newLine)
    }

}



