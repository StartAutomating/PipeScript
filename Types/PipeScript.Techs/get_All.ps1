<#
.SYNOPSIS
    Gets all items in the collection
.DESCRIPTION
    Gets all items in the object.

    This would be all Technologies, Languages, or Interpreters.
.NOTES
    Any noteproperties that are instance properties will be returned.
.EXAMPLE
    $PsLanguages.All
.EXAMPLE
    $PSInterpreters.All
.EXAMPLE
    $PSTechs.All
#>
,@(foreach ($psProperty in $this.PSObject.properties) {
    if ($psProperty -isnot [psnoteproperty]) { continue  }
    if ($psProperty.IsInstance) {
        $psProperty.Value
    }    
})