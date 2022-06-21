<#
.Synopsis
    Makes Output from a PowerShell function Explicit.
.Description
    Makes a PowerShell function explicitly output.

    All statements will be assigned to $null, unless they explicitly use Write-Output or echo.

    If Write-Output or echo is used, the command will be replaced for more effecient output.
#>
[OutputType([Collections.IDictionary])]
param(
[Parameter(Mandatory,ValueFromPipeline)]
[ScriptBlock]
$ScriptBlock
)

process {
    $pipelines = $ScriptBlock.Ast.FindAll({
        param($ast) $ast -is [System.Management.Automation.Language.PipelineAst]        
    }, $false)

    $astReplacements = [Ordered]@{}
    foreach ($pipeline in $pipelines) {
        $pipelineParent = $pipeline.Parent
        $pipelineGrandParent = $pipeline.Parent.Parent
        
        if ($pipelineParent -is [Management.Automation.Language.CommandAst] -or        
            $pipelineGrandParent -is [Management.Automation.Language.CommandAst]) {
            continue
        }
        if ($pipelineParent -is [Management.Automation.Language.AssignmentStatementAst] -or
            $pipelineGrandParent -is [Management.Automation.Language.AssignmentStatementAst]) {
            continue
        }
        if ($pipelineParent -is [Management.Automation.Language.ReturnStatementAst] -or
            $pipelineGrandParent -is [Management.Automation.Language.ReturnStatementAst]
        ) {
            continue
        }
        $nullify = $pipeline.PipelineElements[-1] -isnot [System.Management.Automation.Language.CommandAst]
        if (-not $nullify) {
            $cmdName = $pipeline.PipelineElements[-1].CommandElements[0].Value
            $isOutputCmdName = '^(?>Out|Write|Show|Format)'
            $resolvedAlias = $ExecutionContext.SessionState.InvokeCommand.GetCommand($cmdName, 'Alias')
            $nullify = 
                $cmdName -notmatch $isOutputCmdName -and
                $resolvedAlias.Definition -notmatch $isOutputCmdName
        
            $isWriteOutput = $cmdName -in 'Write-Output', 'echo', 'write'
            if ($isWriteOutput) {
                if ($pipeline.PipelineElements.Count -gt 1) {
                    
                    $strPipeline = "$pipeline" # .PipelineElements[0..($pipeline.PipelineElements.Count - 2)]
                    $restOfPipeline = $strPipeline.Substring(0, $strPipeline.Length - $pipeline.PipelineElements[-1].ToString().Length)
                    
                    $astReplacements[$pipeline] = [ScriptBlock]::Create($restOfPipeline.TrimEnd().TrimEnd('|'))
                } else {
                    $ce = $pipeline.PipelineElements[0].CommandElements
                    $astReplacements[$pipeline] = [ScriptBlock]::Create($ce[1..($ce.Count - 1)] -join ' ')

                }
                continue
            }
        }

        if ($nullify) {
            $astReplacements[$pipeline] =  [ScriptBlock]::Create("`$null = $pipeline")
        }
    }
    $astReplacements
    # @{AstReplacement=$astReplacements}    
}
