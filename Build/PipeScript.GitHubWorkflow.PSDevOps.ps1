#requires -Module PSDevOps,GitPub
Import-BuildStep -SourcePath (
    Join-Path $PSScriptRoot 'GitHub'
) -BuildSystem GitHubWorkflow

Push-Location ($PSScriptRoot | Split-Path)
New-GitHubWorkflow -Name "Analyze, Test, Tag, and Publish" -On Push,
    PullRequest, 
    Demand -Job PowerShellStaticAnalysis, 
    TestPowerShellOnLinux, 
    TagReleaseAndPublish, 
    BuildPipeScript -OutputPath .\.github\workflows\TestAndPublish.yml

New-GitHubWorkflow -On Demand -Job RunGitPub -Name GitPub -OutputPath .\.github\workflows\GitPub.yml

Pop-Location