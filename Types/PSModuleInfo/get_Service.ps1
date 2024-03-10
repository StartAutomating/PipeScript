<#
.SYNOPSIS
    Gets Module Services
.DESCRIPTION
    Gets any services associated with a module.

    Services can be defined within a module's metadata (`.PrivateData` or `.PrivateData.PSData`)

    Services are defined within the `.Service','.Services','.WebService','.WebServices','.WebCommand','.WebCommands' sections of the manifest metadata.
#>
param()


if (-not $this.'.Services') {
    $this | Add-Member NoteProperty '.Services' (
        [PSCustomObject][Ordered]@{
            PSTypeName = 'PipeScript.Module.Services'
            List = @(foreach ($potentialServer in $this.FindMetadata(
                'Service', 'Services',
                'WebService', 'WebServices', 
                'WebCommand', 'WebCommands'
            )) {
            $potentialServer.pstypenames.clear()
            $potentialServer.pstypenames.add("$this.Service")
            $potentialServer.pstypenames.add('PipeScript.Module.Service')
            $potentialServer
        })
        }        
    ) -Force
}

$this.'.Services'


