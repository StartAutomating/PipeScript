<#
.SYNOPSIS
    Determines if an object has define a property
.DESCRIPTION
    Determines if an object has define a property (as opposed to inheriting it)    
.NOTES
    This makes .PSObject more similar to a JavaScript prototype.
#>
param(
# The property name.
[string]
$PropertyName
)

if ($PropertyName) {
    if (-not $this.Properties[$PropertyName]) {
        return $false
    }
    return $this.Properties[$PropertyName].IsInstance
}







