<#
.SYNOPSIS
    Gets all Parsers
.DESCRIPTION
    Gets all parsers loaded in PipeScript.
#>
,@(foreach ($psProperty in $this.PSObject.properties) {
    if ($psProperty -isnot [psnoteproperty]) { continue  }    
    if ($psProperty.Value -isnot [Management.Automation.CommandInfo]) { continue }
    $psProperty.Value
})