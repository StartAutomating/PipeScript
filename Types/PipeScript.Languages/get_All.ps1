<#
.SYNOPSIS
    Gets all Languages
.DESCRIPTION
    Gets all currently loaded language definitions in PipeScript.
#>
,@(foreach ($psProperty in $this.PSObject.properties) {
    if ($psProperty -isnot [psnoteproperty]) { continue  }    
    if ($psProperty.Value -isnot [PSObject]) { continue }
    if ($prop.IsInstance -and $prop.Value.LanguageName) {
        $psProperty.Value
    }    
})