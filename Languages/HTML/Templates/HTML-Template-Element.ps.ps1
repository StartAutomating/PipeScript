[ValidatePattern("HTML")]
param()

Template function HTML.Element {
    <#
    .SYNOPSIS
        Template for an HTML element.
    .DESCRIPTION
        A Template for an HTML element.
    .LINK
        https://developer.mozilla.org/en-US/docs/Web/HTML/Element
    #>
    [Alias('Template.Element.html')]
    param(
    # The name of the element.
    [vbn()]
    [string]
    $Name,
    
    # The attributes of the element.
    [vbn()]
    [Alias('Attribute')]
    [PSObject]
    $Attributes,
    
    # The content of the element.
    [vbn()]
    [string]
    $Content
    )
    
    process {
        $attributesString = if ($Attributes) {
            if ($attributes -is [Collections.IDictionary]) {
                $attributes = [PSCustomObject]$attributes
            }
            @(foreach ($property in $attributes.PSObject.Properties) {
                $propertyName = $property.Name -replace '([A-Z])', '-$1' -replace '^-', ''
                $propertyValue = $property.Value
                " $propertyName='$propertyValue'"
            }) -join ''            
        }

        if ($content) {
            "<${Name}${AttributeString} />" -replace "\s{1,}\/\>$", "/>"
        } else {
            "<${Name}${attributesString}>$Content</$Name>"
        }                
    }
}
