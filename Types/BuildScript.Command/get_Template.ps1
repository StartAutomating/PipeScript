$potentialTemplatePaths =
    @(
        $this.Source -replace '\.ps1$', '.ps.ps1'
        $this.Source -replace '\.ps1$', '.ps1.ps1'
    )

foreach ($potentialTemplatePath in $potentialTemplatePaths ) {
    if (Test-Path $potentialTemplatePath) {
        return (Get-PipeScript -PipeScriptPath $potentialTemplatePath)
    }    
}

