<#
.SYNOPSIS
    Gets Module Websites
.DESCRIPTION
    Gets any websites associated with a module.

    Websites can be defined within a module's `.PrivateData` or `.PrivateData.PSData`

    Websites are defined within the `.Site`,`.Sites`,`.Website`,`.Websites` sections of the manifest.    
#>
param()

, @(foreach ($potentialServer in $this.FindMetadata('Site', 'Sites', 'Website', 'Websites')) {
    $potentialServer.pstypenames.clear()
    $potentialServer.pstypenames.add("$this.Website")
    $potentialServer.pstypenames.add('PipeScript.Module.Website')
    $potentialServer
})