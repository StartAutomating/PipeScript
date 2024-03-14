if ($this.psobject.properties['_CachedMetadata']) {
    return $this._CachedMetadata
}


$topicData = :FindingMetadata foreach ($potentialExtension in '.psd1','.json','.csv') {
    $potentialFileName = $this.Name + $potentialExtension    
    $potentialFullName = $this.Fullname + $potentialExtension
    if (Test-Path $potentialFullName) {
        switch ($potentialExtension) {
            '.psd1' {
                try {
                    $localizedData = Import-LocalizedData -BaseDirectory $this.Directory.Fullname -FileName $psd1FileName
                    $importedData = [Ordered]@{}
                    if ($localizedData) {
                        $localizedData.GetEnumerator() | 
                        Sort-Object { $_.Key.ToLower() }|
                        & { process {
                            $importedData[$_.Key.ToLower()] = $_.Value
                        } }
                    }
                    $importedData
                    break FindingMetadata
                } catch {
                    Write-Warning "$_"
                    @{}
                }
                break
            }
            '.json' {
                Get-Content $potentialFullName -Raw | ConvertFrom-Json
                break FindingMetadata                
            }
            '.csv' {
                Import-Csv $potentialFullName
                break FindingMetadata
            }
        }
    }
}

if (-not $topicData) { $topicData = [Ordered]@{} }
if ($topicData -isnot [Collections.IDictionary]) {
    $topicDataDictionary = [Ordered]@{}
    foreach ($property in $topicData.psobject.properties) {
        $topicDataDictionary[$property.Name] = $property.Value
    }
    $topicData = $topicDataDictionary
}

$this | Add-Member NoteProperty _CachedMetadata $topicData -Force
return $topicData