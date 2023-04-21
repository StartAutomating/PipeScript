function Export-Pipescript {
    <#
    .Synopsis
        Builds and Exports using PipeScript
    .Description
        Builds and Exports a path, using PipeScript.
        
        Any Source Generator Files Discovered by PipeScript will be run, which will convert them into source code.
    .EXAMPLE
        Export-PipeScript
    .EXAMPLE
        Build-PipeScript
    #>
    [Alias('Build-PipeScript','bps','eps')]
    param(
    # One or more input paths.  If no -InputPath is provided, will build all scripts beneath the current directory.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('FullName')]
    [string[]]
    $InputPath
    )

    process {
        $filesToBuild = 
            @(if (-not $InputPath) {
                Get-PipeScript -PipeScriptPath $pwd |
                    Where-Object PipeScriptType -In Template, BuildScript |
                    Sort-Object PipeScriptType, Source
            } else {
                foreach ($inPath in $InputPath) {
                    Get-PipeScript -PipeScriptPath $inPath |
                        Where-Object PipeScriptType -In Template, BuildScript |
                        Sort-Object PipeScriptType, Source
                }
            })
        
        $buildStarted = [DateTime]::Now
        $alreadyBuilt = [Ordered]@{}
        $filesToBuildCount, $filesToBuildTotal, $filesToBuildID  = 0, $filesToBuild.Length, $(Get-Random)
        foreach ($buildFile in $filesToBuild) {
            
            $ThisBuildStartedAt = [DateTime]::Now                

            Write-Progress "Building PipeScripts [$FilesToBuildCount / $filesToBuildTotal]" "$($buildFile.Source) " -PercentComplete $(
                $FilesToBuildCount++
                $FilesToBuildCount * 100 / $filesToBuildTotal 
            ) -id $filesToBuildID

            if ($alreadyBuilt[$buildFile.Source]) { continue }

            $buildFileTemplate = $buildFile.Template
            if ($buildFileTemplate -and $buildFile.PipeScriptType -ne 'Template') {
                try {
                    Invoke-PipeScript $buildFileTemplate.Source
                } catch {
                    $ex = $_
                    Write-Error -ErrorRecord $ex
                }
                $alreadyBuilt[$buildFileTemplate.Source] = $true
            }

            $EventsFromThisBuild = Get-Event | 
                Where-Object TimeGenerated -gt $ThisBuildStartedAt |
                Where-Object SourceIdentifier -Like '*PipeScript*'
            
            try {
                Invoke-PipeScript $buildFile.Source
            } catch {
                $ex = $_
                Write-Error -ErrorRecord $ex
            }

            $alreadyBuilt[$buildFile.Source] = $true
        }


        $BuildTime = [DateTime]::Now - $buildStarted
        Write-Progress "Building PipeScripts [$FilesToBuildCount / $filesToBuildTotal]" "Finished In $($BuildTime) " -Completed -id $filesToBuildID
    }
}
