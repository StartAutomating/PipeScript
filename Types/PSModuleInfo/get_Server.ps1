<#
.SYNOPSIS
    Gets Module Servers
.DESCRIPTION
    Gets any servers associated with a module.

    Servers can be defined within a module's `.PrivateData` or `.PrivateData.PSData`

    Servers are defined within the `.Server','.Servers','.Domain','.Domains','.HostHeader','.HostHeaders' sections of the manifest.    
#>
param()

, @(foreach ($potentialServer in $this.FindMetadata('Server', 'Servers', 'Domain', 'Domains', 'HostHeader', 'HostHeaders')) {
    $potentialServer.pstypenames.clear()
    $potentialServer.pstypenames.add("$this.Server")
    $potentialServer.pstypenames.add('PipeScript.Module.Server')
    $potentialServer
})