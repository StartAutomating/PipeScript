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
    $DefaultSiteData = [Ordered]@{PSTypeName='PipeScript.Module.Website';Mirrors=@()}
    
    $firstPropertyBag = $true
    $listOfUrls = @()
    $theseWebsites = 
    foreach ($potentialSite in $this.FindMetadata('Site', 'Sites', 'Website', 'Websites')) {
        if ($potentialSite -is [string]) {
            $listOfUrls+= $potentialSite
        } else {
            if ($potentialSite -is [Collections.IDictionary]) {
                $potentialSite = [PSCustomObject]$potentialSite            
            }
            $potentialSite.pstypenames.insert(0, 'PipeScript.Module.Website')
            $potentialSite.pstypenames.insert(0, "$this.Website")
            if ($listOfUrls) {
                $firstUrl, $allOtherUrls = $listOfUrls
                if (-not $potentialSite.Url) {
                    $potentialSite.psobject.properties.add([psnoteproperty]::new("Url", $firstUrl))                    
                } else {
                    $allOtherUrls = $listOfUrls
                }
                if ($allOtherUrls) {
                    if ($potentialSite.Mirrors) {
                        $potentialSite.Mirrors = @($potentialSite.Mirrors) +  $allOtherUrls
                    } elseif ($potentialSite.Mirror) {
                        $potentialSite.Mirror = @($potentialSite.Mirror) +  $allOtherUrls
                    }
                    else {
                        $potentialSite.psobject.properties.add([psnoteproperty]::new("Mirrors", $allOtherUrls))
                    }                    
                }
                $listOfUrls = @()
            }
            $potentialSite            
        }
    }

    if (-not $theseWebsites) {
        if ($listOfUrls) {
            $firstUrl, $allOtherUrls = $listOfUrls
            $DefaultSiteData.Url = $firstUrl
            if ($allOtherUrls) {
                $DefaultSiteData.Mirrors = $allOtherUrls
            }
        }
        $theseWebsites = $DefaultSiteData
    }
    
    $this | Add-Member NoteProperty ".Website" $theseWebsites -Force
}

return $this.'.Website'
