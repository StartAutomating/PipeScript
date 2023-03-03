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

process {
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
        "}"
    )
    # Create a new script block
    $transpiledFunction = [ScriptBlock]::Create($newFunction -join [Environment]::NewLine)

    # Now, determine the dynamic name of a module.
    $dynamicModuleName = 
        if ($FunctionDefinition.Extent.File) {
            $FunctionDefinition.Extent.File | Split-Path -Leaf
        } else {
            "PipeScriptDefinedFunctions"
        }

    # If one already exists, we'll need to merge it
    $moduleExists = Get-Module -Name $dynamicModuleName
    $moduleDefinition = 
        if ($moduleExists) {
            [ScriptBlock]::Create(($moduleExists.Definition, $transpiledFunction -join [Environment]::newLine))
            # and remove it
            $moduleExists | Remove-Module        
        } else {
            $transpiledFunction
        }
    
    # Create a dynamic module and import it globally.
    New-Module -Name $dynamicModuleName -ScriptBlock $moduleDefinition |
        Import-Module -Global -Force

    # Create an event indicating that a function has been transpiled.
    $null = New-Event -SourceIdentifier PipeScript.Function.Transpiled -MessageData ([PSCustomObject][Ordered]@{
        PSTypeName = 'PipeScript.Function.Transpiled'
        FunctionDefinition = $FunctionDefinition
        ScriptBlock = $transpiledFunction
    })

    # Output the transpiled function.
    $transpiledFunction
}
