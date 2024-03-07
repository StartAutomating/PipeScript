[ValidatePattern("Pipescript")]
param()


function Template.PipeScript.ExplicitOutput {

    <#
    .Synopsis
        Makes Output from a PowerShell function Explicit.
    .Description
        Makes a PowerShell function explicitly output.

        All statements will be assigned to $null, unless they explicitly use Write-Output or echo.

        If Write-Output or echo is used, the command will be replaced for more effecient output.
    .EXAMPLE
        Invoke-PipeScript {
            [explicit()]
            param()
            "This Will Not Output"
            Write-Output "This Will Output"
        }
    .EXAMPLE
        {
            [explicit]{
                1,2,3,4
                echo "Output"
            }
        } | .>PipeScript
    #>
    [OutputType([ScriptBlock])]
    [Alias('Explicit','ExplicitOutput')]
    param(
    # The ScriptBlock that will be transpiled.
    [Parameter(Mandatory,ValueFromPipeline)]
    [ScriptBlock]
    $ScriptBlock
    )

    process {
        # Search the ScriptBlock for
        $pipelines = $ScriptBlock.Ast.FindAll({
            param($ast)
            # all pipelines  
            if ($ast -isnot [System.Management.Automation.Language.PipelineAst]) {
                return $false
            }
            # (as long as they are not the child or grandchild of Command, Assignment, or Return statements)
            $ignoreTypes = 'CommandAst', 'AssignmentStatementAst', 'ReturnStatementAst'
            $pipelineParent = $ast.Parent
            $pipelineGrandParent = $ast.Parent.Parent
            if ($pipelineParent -and $pipelineParent.GetType().Name -in $ignoreTypes) {
                return $false
            }
            if ($pipelineGrandParent -and $pipelineGrandParent.GetType().Name -in $ignoreTypes) {
                return $false
            }        
            return $true
        }, $false)

        $astReplacements = [Ordered]@{}
        foreach ($pipeline in $pipelines) {        
            $nullify = $pipeline.PipelineElements[-1] -isnot [Management.Automation.Language.CommandAst]
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
                        $strPipeline = "$pipeline"
                        $restOfPipeline = $strPipeline.Substring(0,
                            $strPipeline.Length - $pipeline.PipelineElements[-1].ToString().Length)
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

        Update-PipeScript -ScriptBlock $ScriptBlock -AstReplacement $astReplacements    
    }

}

