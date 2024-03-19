<#
.SYNOPSIS
    Builds a container image.
.DESCRIPTION
    Builds a container image for the module.
#>
param()
$buildTag = 
    if (-not $this.Tag) {
        "$($this.Module)"
    } else {
        $this.Tag
    }

$dockerFilePath = 
    if ($this.Dockerfile) {
        if (@($this.Dockerfile -split '[\r\n]+' -ne '').Length -gt 1) {
            $dockerFilePath = (Join-Path ($this.Module | Split-Path) Dockerfile)    
            
            if (Test-Path $dockerFilePath) {
                $dockerFilePath = 
                    Join-Path -Path (
                        $this.Module | Split-Path
                    ) -ChildPath (
                        [datetime]::Now.ToString("s") -replace ':', '_' + ".Dockerfile"
                    )
            }
            (New-Item -ItemType File -Path $dockerFilePath -Value $this.Dockerfile -Force).FullName
        }
    
        $dockerFilePath = (Join-Path ($this.Module | Split-Path) $this.Dockerfile)
        if (Test-Path $dockerFilePath) {
            $dockerFilePath
        } 
    }

$ProgressId = Get-Random
foreach ($lineOut in docker build --tag $buildTag --file $dockerFilePath ($this.Module | Split-Path) *>&1) {
    if ($lineOut -isnot [string] -and $lineOut -isnot [Management.Automation.ErrorRecord]) {
        $lineOut
        continue
    }

    if ("$lineOut" -match "\#(?<StepNumber>\d+)\s(?:\[(?<StageNumber>\d+)/(?<StageCount>\d+)\])?(?<Message>.+$)") {
        $MatchInfo = [Ordered]@{} + $matches
        Write-Progress -Activity "$($MatchInfo.StepNumber) $(
            if ($MatchInfo.StageNumber) {"[$($matchInfo.StageNumber)/$($matchInfo.StageCount)]"
        })" -Status "$($MatchInfo.Message)"  -id $ProgressId
    }
    if ($PSStyle) {        
        "$($psStyle.Foreground.Cyan)$lineOut$($PSStyle.Reset)" | Write-Host
    } else {
        "$lineOut"
    }
    
}

Write-Progress -Activity "Docker Build" -Status "Complete" -id $ProgressId -Completed
