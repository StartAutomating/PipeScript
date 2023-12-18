<#
.SYNOPSIS
    Determines if a property is enumerable
.DESCRIPTION
    Determines if a property or object is enumerable.    

    If no PropertyName is provided, this method will determine if the .ImmediateBaseObject is enumerable.
.NOTES
    This makes .PSObject more similar to a JavaScript prototype.
#>
param(
# The property name.
# If this is not provided, this method will determine if the .ImmediateBaseObject is enumerable.
[string]
$PropertyName
)

if ($PropertyName) {
    if (-not $this.Properties[$PropertyName]) {
        return $false
    }
    return $this.Properties[$PropertyName].Value -is [Collections.IEnumerable]
} else {
    $this.ImmediateBaseObject -is [Collections.IEnumerable]    
}







