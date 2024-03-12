<#
.SYNOPSIS
    Gets all routes a module serves
.DESCRIPTION
    Gets all routes served by any of the module services.

    (additional routes can also be declared in the module manifest)    
#>
param()

$serviceRoutes = [Ordered]@{PSTypeName='PipeScript.Module.Route'}

foreach ($serviceInfo in $this.List) {
    if ($serviceInfo.GetServiceRoute) {
        $serviceRouteInfo = $serviceInfo.GetServiceRoute()
        if ($serviceRouteInfo) {
            $serviceRoutes[$serviceRouteInfo] = $serviceInfo
        }
    }
}

return [PSCustomObject]$serviceRoutes