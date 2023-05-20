<#
.SYNOPSIS
    PipeScript Function Transpiler
.DESCRIPTION
    Transpiles Function Definitions.
#>
param(
# An abstract syntax tree function definition.
[Parameter(Mandatory,ParameterSetName='FunctionAst',ValueFromPipeline)]
[Management.Automation.Language.FunctionDefinitionAst]
$FunctionDefinition
)

begin {
    $pipeScriptCommands = $ExecutionContext.SessionState.InvokeCommand.GetCommands('PipeScript*', 'Function,Alias', $true)
    foreach ($pipeScriptCommand in $pipeScriptCommands) {
        if ($pipeScriptCommand.Name -match '^PipeScript.(?>Pre|Analyze)' -and 
            $pipeScriptCommand.CouldPipeType([Management.Automation.Language.FunctionDefinitionAst])) {
            $preCommands += $pipeScriptCommand
        }
        if ($pipeScriptCommand.Name -match '^PipeScript.(?>Post|Optimize)' -and
            $pipeScriptCommand.CouldPipeType([Management.Automation.Language.FunctionDefinitionAst])
        ) {
            $postCommands += $pipeScriptCommand
        }
    }
    $preCommands  = $preCommands | Sort-Object Rank, Name
    $postCommands = $postCommands | Sort-Object Rank, Name
}

process {
    #region PreCommands
    if ($preCommands) {
        foreach ($pre in $preCommands) {
            $preOut = $FunctionDefinition | & $pre
            if ($preOut -and $preOut -is [Management.Automation.Language.FunctionDefinitionAst]) {
                $FunctionDefinition = $preOut
            }
        }
    }
    #endregion PreCommands

    $TranspilerSteps = @()
    $realFunctionName = $functionDefinition.Name
    if ($FunctionDefinition.Name -match '\W(?<Name>\w+)$' -or
        $FunctionDefinition.Name -match '^(?<Name>[\w-]+)\W') { 
        
        $TranspilerSteps = @([Regex]::new('
            ^\s{0,}
            (?<BalancedBrackets>
            \[                  # An open bracket
            (?>                 # Followed by...
                [^\[\]]+|       # any number of non-bracket character OR
                \[(?<Depth>)|   # an open bracket (in which case increment depth) OR
                \](?<-Depth>)   # a closed bracket (in which case decrement depth)
            )*(?(Depth)(?!))    # until depth is 0.
            \]                  # followed by a closing bracket
            ){0,}
        ', 'IgnoreCase,IgnorePatternWhitespace','00:00:00.1').Match($FunctionDefinition.Name).Groups["BalancedBrackets"])

        if ($TranspilerSteps ) {
            $transpilerStepsEnd     = $TranspilerSteps[-1].Start + $transpilerSteps[-1].Length                
            $realFunctionName       = $functionDefinition.Name.Substring($transpilerStepsEnd)
        }
    }

    $inlineParameters =
        if ($FunctionDefinition.Parameters) {
            "($($FunctionDefinition.Parameters.Transpile() -join ','))"
        } else {
            ''
        }
    $partialCommands = 
        @(
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
        })    
    
    $newFunction = @(
        if ($FunctionDefinition.IsFilter) {
            "filter", $realFunctionName, $inlineParameters, '{' -ne '' -join ' '
        } else {
            "function", $realFunctionName, $inlineParameters, '{' -ne '' -join ' '
        }
        # containing the transpiled funciton body.
        $transpiledFunctionBody = [ScriptBlock]::Create(($functionDefinition.Body.Extent -replace '^{' -replace '}$')) |
            .>Pipescript -Transpiler $transpilerSteps        
        
        # If there were not partial commands, life is easy, we just return the transpiled ScriptBlock
        if (-not $partialCommands) {
            $transpiledFunctionBody
        } else {
            # If there were any partial commands,
            @(                
                $transpiledFunctionBody # we join them with the transpiled code.
                $alreadyIncluded = [Ordered]@{} # Keep track of what we've included.
                foreach ($partialCommand in $partialCommands) { # and go over each partial command                                        
                    if ($alreadyIncluded["$partialCommand"]) { continue }
                    # and get it's ScriptBlock
                    if ($partialCommand.ScriptBlock) {
                        $partialCommand.ScriptBLock
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
            ) | # Take all of the combined input and pipe in into Join-PipeScript
                Join-PipeScript -Transpile
        }
        "}"
    )
    # Create a new script block
    $transpiledFunction = [ScriptBlock]::Create($newFunction -join [Environment]::NewLine)

    $transpiledFunctionAst = $transpiledFunction.Ast.EndBlock.Statements[0]
    if ($postCommands -and 
        $transpiledFunctionAst -is [Management.Automation.Language.FunctionDefinitionAst]) {
        foreach ($post in $postCommands) {
            $postOut = $transpiledFunctionAst | & $post
            if ($postOut -and $postOut -is [Management.Automation.Language.FunctionDefinitionAst]) {
                $transpiledFunctionAst = $postOut
            }
        }

        $transpiledFunction = [scriptblock]::Create("$transpiledFunctionAst")
    }

    Import-PipeScript -ScriptBlock $transpiledFunction -NoTranspile
    # Create an event indicating that a function has been transpiled.
    $null = New-Event -SourceIdentifier PipeScript.Function.Transpiled -MessageData ([PSCustomObject][Ordered]@{
        PSTypeName = 'PipeScript.Function.Transpiled'
        FunctionDefinition = $FunctionDefinition
        ScriptBlock = $transpiledFunction
    })

    # Output the transpiled function.
    $transpiledFunction
}
