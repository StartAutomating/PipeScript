#requires -Module PSDevOps
#requires -Module PipeScript
Import-BuildStep -SourcePath (
    Join-Path $PSScriptRoot 'GitHub'
) -BuildSystem GitHubAction

Push-Location ($PSScriptRoot | Split-Path)
New-GitHubAction -Name "BuildPipeScript" -Description @'
Builds code using PipeScript
'@ -Action PipeScriptAction -Icon code -OutputPath .\action.yml
Pop-Location