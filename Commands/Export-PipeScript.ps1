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
        if ($env:GITHUB_WORKSPACE) {
            "::group::Discovering files", "from: $InputPath" | Out-Host
        }
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

        if ($env:GITHUB_WORKSPACE) {
            "$($filesToBuild.Length) files to build:" | Out-Host
            $filesToBuild.FullName -join [Environment]::NewLine | Out-Host
            "::endgroup::" | Out-Host
        }
        
        $buildStarted = [DateTime]::Now
        $alreadyBuilt = [Ordered]@{}
        $filesToBuildCount, $filesToBuildTotal, $filesToBuildID  = 0, $filesToBuild.Length, $(Get-Random)

        if ($env:GITHUB_WORKSPACE) {
            "::group::Building PipeScripts [$FilesToBuildCount / $filesToBuildTotal]" | Out-Host                
        }
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
                    if ($env:GITHUB_WORKSPACE) {
                        $fileAndLine = @(@($ex.ScriptStackTrace -split [Environment]::newLine)[-1] -split ',\s',2)[-1]
                        $file, $line = $fileAndLine -split ':\s\D+\s', 2
                        
                        "::error file=$File,line=$line::$($ex.Exception.Message)" | Out-Host
                    }
                }
                $alreadyBuilt[$buildFileTemplate.Source] = $true
            }

            $EventsFromThisBuild = Get-Event |
                Where-Object TimeGenerated -gt $ThisBuildStartedAt |
                Where-Object SourceIdentifier -Like '*PipeScript*'
            
            $FileBuildStarted = [datetime]::now
            $buildOutput = 
                try {
                    Invoke-PipeScript $buildFile.Source
                } catch {
                    $ex = $_
                    Write-Error -ErrorRecord $ex
                }

            if ($buildOutput) {
                if ($env:GITHUB_WORKSPACE) {
                    "$($buildFile.Source) [$([datetime]::now - $FileBuildStarted)]" | Out-Host
                    if ($buildOutput -is [Management.Automation.ErrorRecord]) {
                        $buildOutput | Out-Host
                    } else {
                        $buildOutput.FullName | Out-Host
                    }
                }
                
                $buildOutput
            }
            
            $alreadyBuilt[$buildFile.Source] = $true
        }
        $BuildTime = [DateTime]::Now - $buildStarted
        if ($env:GITHUB_WORKSPACE) {
            "$filesToBuildTotal in $($BuildTime)" | Out-Host
            "::endgroup::Building PipeScripts [$FilesToBuildCount / $filesToBuildTotal] : $($buildFile.Source)" | Out-Host                
        }
        
        Write-Progress "Building PipeScripts [$FilesToBuildCount / $filesToBuildTotal]" "Finished In $($BuildTime) " -Completed -id $filesToBuildID
    }
}
