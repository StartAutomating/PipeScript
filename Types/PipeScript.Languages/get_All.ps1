<#
.SYNOPSIS
    Gets all Languages
.DESCRIPTION
    Gets all currently loaded language definitions in PipeScript.
#>
,@(foreach ($psProperty in $this.PSObject.properties) {
    if ($psProperty -isnot [psnoteproperty]) { continue  }
    if ($psProperty.IsInstance -and $psProperty.Value.LanguageName) {
        $psProperty.Value
    }    
})