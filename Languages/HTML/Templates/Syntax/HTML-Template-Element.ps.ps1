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
    [Alias('Attributes')]
    [PSObject]
    $Attribute,
    
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
                if ($propertyValue -is [switch]) {
                    $propertyValue = $propertyValue -as [bool]
                    " $propertyName=$($propertyValue.ToString().ToLower())"
                }
                elseif ($propertyValue -is [int] -or $propertyValue -is [double]) {
                    " $propertyName='$propertyValue'"
                } else {
                    " $propertyName='$propertyValue'"
                }                
            }) -join ''
        }

        if (-not $content) {
            "<${Name}${AttributeString} />" -replace "\s{1,}\/\>$", "/>"
        } else {
            "<${Name}${attributesString}>$Content</$Name>"
        }                
    }
}
