<#
.SYNOPSIS
    Gets Module Websites
.DESCRIPTION
    Gets any websites associated with a module.

    Websites can be defined within a module's `.PrivateData` or `.PrivateData.PSData`

    Websites are defined within the `.Site`,`.Sites`,`.Website`,`.Websites` sections of the manifest.    
#>
param()

if (-not $this.'.Website') { 
    $CombinedSiteData = [Ordered]@{PSTypeName='PipeScript.Module.Website';BaseUrl='';Mirrors=@()}
    
    $firstPropertyBag = $true
    foreach ($potentialSite in $this.FindMetadata('Site', 'Sites', 'Website', 'Websites')) {
        if ($potentialSite -is [string]) {
            if (-not $CombinedSiteData.BaseUrl) {
                $CombinedSiteData.BaseUrl = $potentialSite
            } else {
                $CombinedSiteData.Mirrors += $potentialSite                
            }
        } else {
            if (-not $firstPropertyBag) {
                $CombinedSiteData.Mirrors += $potentialSite
            } else {
                foreach ($prop in $potentialSite.psobject.properties) {
                    $CombinedSiteData[$prop.Name] = $prop.Value
                }
            }
        }
    }
    $CombinedSiteData = [PSCustomObject]$CombinedSiteData
    $CombinedSiteData.pstypenames.insert(0, "$this.Website")
    $this | Add-Member NoteProperty '.Website' $CombinedSiteData -Force    
}

return $this.'.Website'
