<#
.SYNOPSIS
    Gets the service command parameters
.DESCRIPTION
    Gets the parameters to the command (or commands) that a service can uses to run.
#>
param()
$allServiceCommands = 
    foreach ($ext in $PipeScript.Extensions) {
        if ($ext.pstypenames -contains 'Service.Command') {
            $ext
        }
    }

$ThisSplat = [Ordered]@{}
if ($this -is [Collections.IDictionary]) {
    $ThisSplat += $this
} else {
    foreach ($prop in $this.psobject.properties) {
        $ThisSplat[$prop.Name] = $prop.Value
    }
}


foreach ($serviceCommand in $allServiceCommands) {
    $serviceSplat = $serviceCommand.CouldRun($ThisSplat)
    if (-not $serviceCommand.Parameters.Count) { continue }
    if ($serviceSplat) {        
        $serviceSplat.psobject.properties.add([PSNoteProperty]::new('Command', $serviceCommand))
        $serviceSplat
    }
}