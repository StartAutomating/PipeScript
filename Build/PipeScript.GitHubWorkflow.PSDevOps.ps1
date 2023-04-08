#requires -Module PSDevOps
Import-BuildStep -ModuleName PipeScript
Push-Location ($PSScriptRoot | Split-Path)
New-GitHubWorkflow -Name "Analyze, Test, Tag, and Publish" -On Push, PullRequest, Demand -Job PowerShellStaticAnalysis, TestPowerShellOnLinux, TagReleaseAndPublish, BuildPipeScript -Environment @{
    NoCoverage = $true
} -OutputPath .\.github\workflows\TestAndPublish.yml
Pop-Location