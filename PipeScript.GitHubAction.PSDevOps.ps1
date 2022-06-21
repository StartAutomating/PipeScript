#requires -Module PSDevOps
#requires -Module PipeScript
Import-BuildStep -ModuleName PipeScript
New-GitHubAction -Name "BuildPipeScript" -Description 'Builds code using PipeScript' -Action PipeScriptAction -Icon code  -ActionOutput ([Ordered]@{
    PipeScriptRuntime = [Ordered]@{
        description = "The time it took the .PipeScript parameter to run"
        value = '${{steps.PipeScriptAction.outputs.PipeScriptRuntime}}'
    }
    PipeScriptBuildRuntime = [Ordered]@{
        description = "The time it took Build-PipeScript to run"
        value = '${{steps.PipeScriptAction.outputs.PipeScriptBuildRuntime}}'
    }
    PipeScriptFilesBuilt = [Ordered]@{
        description = "The files built using PipeScript (separated by semicolons)"
        value = '${{steps.PipeScriptAction.outputs.PipeScriptFilesBuilt}}'
    }
    PipeScriptFilesBuiltCount = [Ordered]@{
        description = "The number of .PipeScript.ps1 files that were run"
        value = '${{steps.PipeScriptAction.outputs.PipeScriptFilesBuiltCount}}'
    }
}) |
    Set-Content .\action.yml -Encoding UTF8 -PassThru
