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

    $newFunction = @(
        if ($FunctionDefinition.IsFilter) {
            "filter $realFunctionName {"
        } else {
            "function $realFunctionName {"
        }
        # containing the transpiled funciton body.
        [ScriptBlock]::Create(($functionDefinition.Body.Extent -replace '^{' -replace '}$')) |
            .>Pipescript -Transpiler $transpilerSteps
        "}"
    )
    # Create a new script block
    [ScriptBlock]::Create($newFunction -join [Environment]::NewLine)
}
