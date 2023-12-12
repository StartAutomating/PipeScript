<#
.SYNOPSIS
    Gets all Language Templates
.DESCRIPTION
    Gets all templates explicitly related to a language defined in PipeScript.
#>
,@(foreach ($psProperty in $this.PSObject.properties) {
    if ($psProperty -isnot [psnoteproperty]) { continue  }    
    if ($psProperty.Value -isnot [Management.Automation.CommandInfo]) { continue }
    $psProperty.Value
})