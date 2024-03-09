[ValidatePattern("(?>PowerShell|PipeScript)")]
param()


function Template.PowerShell.Attribute {

    <#
    .SYNOPSIS
        Template for a PowerShell Attribute
    .DESCRIPTION
        Writes a value as a PowerShell attribute.
    .NOTES
        This does not check that the type actually exists yet, because it may not.
    .EXAMPLE
        [ValidateSet('a','b','c')] | Template.PowerShell.Attribute
    .EXAMPLE
        Template.PowerShell.Attribute -Type "MyCustomAttribute" -Argument 1,2,3 -Parameter @{Name='Value';Value='Data'}
    #>
    [Alias('Template.PipeScript.Attribute')]
    param(
    # The type of the attribute.  This does not have to exist (yet).
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('TypeID','AttributeType')]
    [PSObject]
    $Type,


    # Any arguments to the attribute.  These will be passed as constructors.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Args','Argument','Arguments','Constructor','Constructors',
        'AttributeArgs','AttributeArguments','AttributeConstructor','AttributeConstructors')]
    [psobject[]]
    $ArgumentList,

    # Any parameters to the attribute.  These will be passed as properties.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('AttributeData','AttributeParameter','AttributeParameters','Parameters','Data')]
    [PSObject[]]
    $Parameter
    )


    begin {
        filter ToAttributeValue {
        
                    if ($_ -is [bool]) {
                        "`$$($_)"
                    } 
                    elseif ($_ -is [int] -or $_ -is [double]) {
                        "$_"
                    }
                    elseif ($_ -is [scriptblock]) {
                        "{$($_)}"
                    } 
                    elseif ($_ -is [type] -or 
                        $_ -as [type[]]) {
                        @(foreach ($t in ($_ -as [type[]]))  {
                            if ($accelerators::get.ContainsValue($t)) {
                                foreach ($acc in $accelerators::get.GetEnumerator()) {
                                    if ($acc.Value -eq $t) {
                                        "[$($acc.Key)]"
                                    }
                                }
                            } else {
                                "[$($t.FullName -replace '^System\.' -replace 'Attribute$')]"
                            }
                        }) -join ','                    
                    }
                    else {
                        "'$($_ -replace "'","''" -join "','")'"                    
                    }            
                
        }
    }
    process {
        if (-not $PSBoundParameters["Parameter"] -and $_ -is [Attribute]) {            
            $parameter = $_            
        }
        
        $visibleProperties =             
            @(
                foreach ($param in $parameter) {
                    if ($param -is [Collections.IDictionary]) {
                        $param = [PSCustomObject]$param
                    }
                    foreach ($property in $param.psobject.properties) {
                        if ($null -ne $property.Value) {
                            if ($property.Name -eq 'TypeID') { continue }
                            $property
                        }
                    }
                }                
            )

        $accelerators = [psobject].assembly.gettype("System.Management.Automation.TypeAccelerators")
        
        $typeName = 
            if (
                ($type -as [Type]) -and 
                ($accelerators::get.ContainsValue(($type -as [Type])))
            ) {
                foreach ($acc in $accelerators::get.GetEnumerator()) {
                    if ($acc.Value -eq ($type -as [Type])) {
                        $acc.Key
                    }
                }
            } elseif ($type.FullName) {
                $Type.FullName -replace '^System\.' -replace 'Attribute$'    
            } else {
                $Type -replace "[\p{P}-[\.]]", '_'
            }
        
        @(
            '['
            $typeName
            '('
        if ($ArgumentList) {
            @($ArgumentList | ToAttributeValue) -join ', '
            ','
        }
        @(foreach ($visibleProperty in $visibleProperties) {
            $visibleValue = @($visibleProperty.Value | ToAttributeValue) -join ','
            $visibleProperty.Name + 
                ' = ' +                 
                $visibleValue
        }) -join ', '
            ')'
            ']'
        ) -join ''
    }

}



