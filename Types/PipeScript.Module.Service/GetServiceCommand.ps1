$allServiceCommands = 
    foreach ($ext in $PipeScript.Extensions) {
        if ($ext.pstypenames -contains 'Service.Command') {
            $ext
        }
    }

$ThisSplat = [Ordered]@{}
foreach ($prop in $this.psobject.properties) {
    $ThisSplat[$prop.Name] = $prop.Value
}

foreach ($serviceCommand in $allServiceCommands) {
    if ($serviceCommand.CouldRun($ThisSplat)) {
        $serviceCommand
    }    
}