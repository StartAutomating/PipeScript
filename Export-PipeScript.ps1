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
                    Where-Object PipeScriptType -In SourceGenerator
            } else {
                foreach ($inPath in $InputPath) {
                    Get-PipeScript -PipeScriptPath $inPath |
                        Where-Object PipeScriptType -In SourceGenerator
                }
            })
        
        
        $buildStarted = [DateTime]::Now
        $filesToBuildCount, $filesToBuildTotal, $filesToBuildID  = 0, $filesToBuild.Length, $(Get-Random)
        foreach ($buildFile in $filesToBuild) {
            $ThisBuildStartedAt = [DateTime]::Now
            Write-Progress "Building PipeScripts [$FilesToBuildCount / $filesToBuildTotal]" "$($buildFile.Source) " -PercentComplete $(
                $FilesToBuildCount++
                $FilesToBuildCount * 100 / $filesToBuildTotal 
            ) -id $filesToBuildID

            $EventsFromThisBuild = Get-Event | 
                Where-Object TimeGenerated -gt $ThisBuildStartedAt |
                Where-Object SourceIdentifier -Like 'PipeScript.*'
            
            Invoke-PipeScript $buildFile.Source 
        }


        $BuildTime = [DateTime]::Now - $buildStarted
        Write-Progress "Building PipeScripts [$FilesToBuildCount / $filesToBuildTotal]" "Finished In $($BuildTime) " -Completed -id $filesToBuildID
    }
}
