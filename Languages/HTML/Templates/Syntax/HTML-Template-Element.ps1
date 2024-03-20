[ValidatePattern("HTML")]
param()


function Template.HTML.Element {

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
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Name,
    
    # The attributes of the element.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Attributes')]
    [PSObject]
    $Attribute,
    
    # The content of the element.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Content
    )
    
    process {
        $attributesString = if ($Attribute) {
            if ($attribute -is [Collections.IDictionary]) {
                $attribute = [PSCustomObject]$attribute
            }
            @(foreach ($property in $attribute.PSObject.Properties) {
                $propertyName = $property.Name -replace '\p{P}','-' -replace '\s','_'
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


