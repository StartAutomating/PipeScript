<#
.SYNOPSIS
    Gets the service's route.
.DESCRIPTION
    Any service can define a route, in a property named `.Route`, `.Routes`, `.Router`, or `.Routers`.

    If the service does not define a route, the function will look for a `ValidatePattern` attribute in the service's command.
    
    If the attribute is found, the function will return a regular expression describing the route.
#>
foreach ($routePropertyName in 'Route', 'Routes','Router','Routers') {
    if ($this.$routePropertyName) {
        return $this.$routePropertyName
    }
}


param()

$setsOfServiceParameters = $this.GetServiceParameters()
foreach ($setOfServiceParameters in $setsOfServiceParameters) {
    $serviceCommand = $setsOfServiceParameters.Command
    foreach ($serviceCommandAttribute in $serviceCommand.ScriptBlock.Attributes) {
        if ($serviceCommandAttribute -isnot [ValidatePattern]) { continue }
        [Regex]::new(
            $(
                if ($serviceCommandAttribute.RegexPattern -match '\$\(\s{0,}\$(?>this|_)') {
                    $_ = $this
                    $ExecutionContext.InvokeCommand.ExpandString(
                        "$($serviceCommandAttribute.RegexPattern)"
                    )                    
                } else {
                    $serviceCommandAttribute.RegexPattern
                }
            ), 
            $serviceCommandAttribute.Options
        )        
    }
}
