<#
.SYNOPSIS
    Gets module assets
.DESCRIPTION
    Gets and caches module assets.

    Assets can be found beneath `/Asset(s)` subdirectories of the module or within `.PrivateData.Asset(s)` or `.PrivateData.PSData.Asset(s)`
#>
param()

if (-not $this.'.Assets') {

    filter ToAssetFile {
        $potentialAssetPath = $_
        if (Test-Path $potentialAssetPath) {
            foreach ($assetItem in Get-Item $potentialAssetPath) {
                $assetItem.pstypenames.add("$this.Asset")
                $assetItem.pstypenames.add('PipeScript.Module.Asset')
                $assetItem        
            }
        }
    }
    
    $this | Add-Member NoteProperty '.Assets' @(foreach ($place in $this.PrivateData, $this.PrivateData.PSData) {
        foreach ($potentialName in 'Asset', 'Assets') {
            $potentialAssets = $place.$potentialName
            if (-not $potentialAssets) { continue }
    
            foreach ($potentialAsset in $potentialAssets) {
    
                    if ($potentialAsset -is [hashtable]) {                
                        $AssetObject = [Ordered]@{}
                        foreach ($sortedKeyValue in $place.$potentialName.GetEnumerator() | Sort-Object Key) {
                            $AssetObject[$sortedKeyValue.Key]= $sortedKeyValue.Value
                        }
                        $AssetObject = [PSCustomObject]$AssetObject                    
                        $AssetObject.pstypenames.clear()
                        $AssetObject.pstypenames.add("$this.Asset")
                        $AssetObject.pstypenames.add('PipeScript.Module.Asset')
                        $AssetObject        
                    } elseif ($potentialAsset) {
                        Join-Path ($this.Path | Split-Path) $potentialAsset | ToAssetFile                                        
                    }
            }
        }
    }) -Force
    
    $this | 
        Split-Path | 
        Get-ChildItem -Directory | 
        Where-Object Name -in 'Asset', 'Assets' | 
        Get-ChildItem -Recurse -File | 
        ToAssetFile
}

$this.'.Assets'

