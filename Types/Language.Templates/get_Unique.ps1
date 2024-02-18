<#
.SYNOPSIS
    Gets unique Language Templates
.DESCRIPTION
    Gets unique templates related to a language.
#>
$distinctCommands = @{}
$ThisPSObject = $this.PSObject
$theseProperties = @($this.PSObject.properties)
foreach ($psProperty in $theseProperties) {
    if ($psProperty -isnot [psnoteproperty]) { continue  }    
    if ($psProperty.Value -isnot [Management.Automation.CommandInfo]) { continue }
    if ($psProperty.Value -is [Management.Automation.AliasInfo]) {            
        $aliasInfo = $psProperty.Value
        if (
            $distinctCommands[$aliasInfo.ResolvedCommand] -or
            $ThisPSObject.Properties[$aliasInfo.ResolvedCommand.Name -replace 'Template\p{P}']
        ) {
            continue
        }            
    }
    $distinctCommands[$psProperty.Value] = $psProperty.Value
    $psProperty.Value
}