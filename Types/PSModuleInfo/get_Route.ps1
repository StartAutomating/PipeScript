<#
.SYNOPSIS
    Gets module routes
.DESCRIPTION
    Gets routes declared by a module.
    
    A module can define routes within it's module manifest (in `.PrivateData` or `.PrivateData.PSData`)

    Routes can be declared in a property named `.Route`,'.Routes','.Router','.Routers'.

    Routes can also be declared by a service's metadata.
#>
param()


foreach ($routeInfo in $this.FindMetadata('Route', 'Routes', 'Router', 'Routers')) {
    $routeInfo.pstypenames.clear()
    $routeInfo.pstypenames.add("$this.Route")
    $routeInfo.pstypenames.add('PipeScript.Module.Route')
    $routeInfo
}

$this.Service.Route