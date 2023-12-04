<#
.SYNOPSIS
    Gets Module Servers
.DESCRIPTION
    Gets any servers associated with a module.

    Servers can be defined within a module's `.PrivateData` or `.PrivateData.PSData`

    Servers are defined within the `.Server','.Servers','.Domain','.Domains','.HostHeader','.HostHeaders' sections of the manifest.    
#>
param()

, @(foreach ($place in $this.PrivateData, $this.PrivateData.PSData) {
    foreach ($potentialName in 'Server', 'Servers','Domain','Domains','HostHeader','HostHeaders') {
        $potentialServers = $place.$potentialName
        if (-not $potentialServers) { continue }

        foreach ($potentialServer in $potentialServers) {
            $potentialServer = 
                if ($potentialServer -is [hashtable]) {                
                    $serverObject = [Ordered]@{}
                    foreach ($sortedKeyValue in $place.$potentialName.GetEnumerator() | Sort-Object Key) {
                        $serverObject[$sortedKeyValue.Key]= $sortedKeyValue.Value
                    }
                    $serverObject = [PSCustomObject]$serverObject                    
                } elseif ($potentialServer) {
                    [PSObject]::new($potentialServer)
                }
            $potentialServer.pstypenames.clear()
            $potentialServer.pstypenames.add("$this.Server")
            $potentialServer.pstypenames.add('PipeScript.Module.Server')
            $potentialServer
        }
    }
})