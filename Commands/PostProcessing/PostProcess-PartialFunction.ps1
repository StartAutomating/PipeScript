
function PipeScript.PostProcess.PartialFunction {


    <#
    .SYNOPSIS
        Expands partial functions
    .DESCRIPTION
        A partial function is a function that will be joined with a function with a matching name.
    .LINK
        Join-PipeScript
    .EXAMPLE
        Import-PipeScript {
            partial function testPartialFunction {
                "This will be added to a command name TestPartialFunction"
            }
            
            function testPartialFunction {}
        }

        testPartialFunction # Should -BeLike '*TestPartialFunction*'
    #>
    param(
    # The function definition.
    [Parameter(Mandatory,ParameterSetName='FunctionDefinition',ValueFromPipeline)]
    [Management.Automation.Language.FunctionDefinitionAst]
    $FunctionDefinitionAst
    )
    

    process {
        $realFunctionName = $FunctionDefinitionAst.Name
        $partialCommands = @(
            if ($realFunctionName -notmatch 'partial\p{P}') {
                if (-not $script:PartialCommands) {
                    $script:PartialCommands =
                    $ExecutionContext.SessionState.InvokeCommand.GetCommands('Partial*',
                        'Function,Alias',$true)
                }
        
                $partialCommands = @(foreach ($partialFunction in $script:PartialCommands) {
                    # Only real partials should be considered.

                    if ($partialFunction -notmatch  'partial\p{P}') { continue }
                    # Partials should not combine with other partials.
                    
                    $partialName = $partialFunction.Name -replace '^Partial\p{P}'
                    if (
                        (
                            # If there's a slash in the name, treat it as a regex
                            $partialName -match '/' -and
                            $realFunctionName -match ($partialName -replace '/')
                        ) -or (
                            # If there's a slash * or ?, treat it as a wildcard
                            $partialName -match '[\*\?]' -and
                            $realFunctionName -like $partialName
                        ) -or (
                            # otherwise, treat it as an exact match.
                            $realFunctionName -eq $partialName
                        )
                    ) {
                        $partialFunction
                    }
                })

                # If there were any partial commands
                if ($partialCommands) {
                    # sort them by rank and name.
                    $partialCommands | Sort-Object Rank, Name
                }
            }
        )
        
        if ((-not $partialCommands)) { return }

        
        $originalDefinition = [ScriptBlock]::Create(($functionDefinitionAst.Body.Extent -replace '^{' -replace '}$'))
        # If there were any partial commands,

        # join them all together first, and skip the help block.
        $partialsToJoin = @(
            $alreadyIncluded = [Ordered]@{} # Keep track of what we've included.
            foreach ($partialCommand in $partialCommands) { # and go over each partial command                                        
                if ($alreadyIncluded["$partialCommand"]) { continue }
                # and get it's ScriptBlock
                if ($partialCommand.ScriptBlock) {
                    $partialCommand.ScriptBlock
                } elseif ($partialCommand.ResolvedCommand) {
                    # (if it's an Alias, keep resolving until we can't resolve anymore).
                    $resolvedAlias = $partialCommand.ResolvedCommand
                    while ($resolvedAlias -is [Management.Automation.AliasInfo]) {
                        $resolvedAlias = $resolvedAlias.ResolvedCommand
                    }
                    if ($resolvedAlias.ScriptBlock) {
                        $resolvedAlias.ScriptBlock
                    }                        
                }
                # Then mark the command as included, just in case.
                $alreadyIncluded["$partialCommand"] = $true
            }
        )

        $joinedPartials = $partialsToJoin | Join-PipeScript -ExcludeBlockType help

        $joinedScriptBlock = @(                
            $originalDefinition # we join them with the transpiled code.
            $joinedPartials
        ) | # Take all of the combined input and pipe in into Join-PipeScript
            Join-PipeScript -Transpile


        $inlineParameters =
            if ($FunctionDefinition.Parameters) {
                "($($FunctionDefinition.Parameters -join ','))"
            } else {
                ''
            }

        $joinedFunction = @(if ($FunctionDefinition.IsFilter) {
            "filter", $realFunctionName, $inlineParameters, '{' -ne '' -join ' '
        } else {
            "function", $realFunctionName, $inlineParameters, '{' -ne '' -join ' '
        }
        $joinedScriptBlock
        "}") -join [Environment]::NewLine
        $joinedFunction = [scriptblock]::Create($joinedFunction)
        $joinedFunction.Ast.EndBlock.Statements[0]        
    }


}


