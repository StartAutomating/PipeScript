<#
.SYNOPSIS
    Gets the route for a URL
.DESCRIPTION
    Gets the route for a given URL
#>
param(
# The URL.
[Alias('URL')]
[uri]
$Uri
)

foreach ($property in $this.psobject.properties) {
    if (-not $property.IsInstance) { continue }
    if ($property -isnot [psnoteproperty]) { continue }
    $propertyPattern = 
        try {
            [Regex]::new($property.Name, 'IgnoreCase,IgnorePatternWhitespace', '00:00:00.01') 
        } catch {
            continue
        }
    if ($propertyPattern.IsMatch("$Uri")) {
        $property.Value
    }
}
