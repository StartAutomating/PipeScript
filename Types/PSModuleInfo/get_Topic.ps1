if (-not $this.'.Topics') {
    $this | Add-Member -MemberType NoteProperty -Name '.Topics' -Value @(
        [PSCustomObject][Ordered]@{
            PSTypeName = 'PipeScript.Module.Topics'
            AllTopics = @(
                foreach ($matchingFile in $this.Files -match '\.(?>md|markdown|help\.txt|topic)$' -notmatch '\.ps1?\.') {
                    $matchingFile.pstypenames.insert(0, 'PipeScript.Module.Topic')
                    $matchingFile.pstypenames.insert(0, "$this.Topic")
                    $matchingFile | Add-Member NoteProperty Module $this -Force -PassThru
                }
            )
            Module = $this
        }        
    ) -Force
}


$this.'.Topics'