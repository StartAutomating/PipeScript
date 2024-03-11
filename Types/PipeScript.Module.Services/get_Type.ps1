<#
.SYNOPSIS
    Gets the types a module serves
.DESCRIPTION
    Gets the types served by the module.
#>

@(foreach ($serviceInfo in $this.List) {
    if ($serviceInfo.Type) {
        $serviceInfo.Type -as [type]
    }
})

