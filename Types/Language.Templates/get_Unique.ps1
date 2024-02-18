<#
.SYNOPSIS
    Gets unique Language Templates
.DESCRIPTION
    Gets unique templates related to a language.
#>
$distinctCommands = @{}
,@(foreach ($psProperty in $this.PSObject.properties) {
    if ($psProperty -isnot [psnoteproperty]) { continue  }    
    if ($psProperty.Value -isnot [Management.Automation.CommandInfo]) { continue }
    if (
        $psProperty.Value -is [Management.Automation.AliasInfo] -and
        (
            $distinctCommands[$psProperty.Value.ResolvedCommand] -or
            $this.PSObject.Properties[$psProperty.Value.ResolvedCommand.Name]
        )
    ) {
        continue
    }
    $distinctCommands[$psProperty.Value] = $psProperty.Value
    $psProperty.Value
})