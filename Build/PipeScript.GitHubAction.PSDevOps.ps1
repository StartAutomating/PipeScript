#requires -Module PSDevOps
#requires -Module PipeScript
Import-BuildStep -ModuleName PipeScript
Push-Location ($PSScriptRoot | Split-Path)
New-GitHubAction -Name "BuildPipeScript" -Description @'
Builds code using PipeScript
'@ -Action PipeScriptAction -Icon code -OutputPath .\action.yml
Pop-Location