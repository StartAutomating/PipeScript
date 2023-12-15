Template function Property.cs {
    <#
    .SYNOPSIS
        Template for CSharp Property
    .DESCRIPTION
        A Template for a CSharp Property Definition
    #>
    param(
    # The property name.
    [vbn()]
    [Alias('Identifier','Name','PropertyName')]
    [string]
    $Property,
    
    # The class modifiers.  Creates public properties by default.
    [vbn()]
    [Alias('Modifiers')]
    [string[]]
    $Modifier = 'public',    

    # The property type.  By default, object.
    [vbn()]    
    [string]
    $PropertyType = 'object',

    # One or more property attributes
    [vbn()]
    [Alias('Attributes','PropertyAttribute','PropertyAttributes')]
    [string[]]
    $Attribute,

    # The body of the property.
    [vbn()]
    [Alias('Members','Member')]
    [string[]]
    $Body
    )
        
    process {
@"
$(if ($Attribute) {($Attribute -join [Environment]::NewLine) + [Environment]::NewLine})$($Modifier -join ' ') $propertyType $property {$(
    if (-not $body) { "get;set;"}
    else { $($body -join [Environment]::NewLine) } 
)}
"@
    }    
}
