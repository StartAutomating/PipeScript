<#
.SYNOPSIS
    Gets the number of language templates
.DESCRIPTION
    Gets the number of templates explicitly related to a language defined in PipeScript.
#>
@(foreach ($psProperty in $this.PSObject.properties) {
    if ($psProperty -isnot [psnoteproperty]) { continue  }    
    if ($psProperty.Value -isnot [Management.Automation.CommandInfo]) { continue }
    $psProperty.Value
}).Length