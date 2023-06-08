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
    $pipeScriptCommands = @($ExecutionContext.SessionState.InvokeCommand.GetCommands('PipeScript*', 'Function,Alias', $true)) -match '^PipeScript\.(?>Pre|Post|Analyze|Optimize)'
    $preCommands = @()
    $postCommands = @()
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
    
    $newFunction = @(
        if ($FunctionDefinition.IsFilter) {
            "filter", $realFunctionName, $inlineParameters, '{' -ne '' -join ' '
        } else {
            "function", $realFunctionName, $inlineParameters, '{' -ne '' -join ' '
        }
        # containing the transpiled funciton body.
        [ScriptBlock]::Create(($functionDefinition.Body.Extent -replace '^{' -replace '}$')) |
            .>Pipescript -Transpiler $transpilerSteps        
                
        $transpiledFunctionBody                
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
