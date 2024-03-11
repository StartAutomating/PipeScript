<#
.SYNOPSIS
    Gets the service command
.DESCRIPTION
    Gets the command or commands that a service can use to run.
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
    if (-not $serviceCommand.Parameters.Count) { continue }
    if ($serviceCommand.CouldRun($ThisSplat)) {
        $serviceCommand
    }    
}