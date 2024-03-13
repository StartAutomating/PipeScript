if ($this.psobject.properties['_CachedMetadata']) {
    return $this._CachedMetadata
}


$topicData = foreach ($potentialExtension in '.psd1','.json','.csv') {
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
                } catch {
                    Write-Warning "$_"
                    @{}
                }
                break
            }
            '.json' {
                Get-Content $potentialFullName -Raw | ConvertFrom-Json
                break
            }
            '.csv' {
                Import-Csv $potentialFullName
                break
            }
        }
    }
}

$this | Add-Member NoteProperty _CachedMetadata $topicData -Force
return $topicData