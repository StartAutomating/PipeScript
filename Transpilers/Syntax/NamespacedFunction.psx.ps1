<#
.SYNOPSIS
    Namespaced functions
.DESCRIPTION
    Allows the declaration of a function or filter in a namespace.
    
    Namespaces are used to logically group functionality and imply standardized behavior.    
.EXAMPLE
    {
        abstract function Point {
            param(
            [Alias('Left')]
            [vbn()]
            $X,

            [Alias('Top')]
            [vbn()]
            $Y
            )
        }
    }.Transpile()
.EXAMPLE
    {
        interface function AccessToken {
            param(
            [Parameter(ValueFromPipelineByPropertyName)]
            [Alias('Bearer','PersonalAccessToken', 'PAT')]
            [string]
            $AccessToken
            )
        }
    }.Transpile()
.EXAMPLE
    {
        partial function PartialExample {
            process {
                1
            }
        }

        partial function PartialExample* {
            process {
                2
            }
        }

        partial function PartialExample// {
            process {
                3
            }
        }        

        function PartialExample {
            
        }
    }.Transpile()
#>
[Reflection.AssemblyMetaData('Order', -10)]
[ValidateScript({
    # This only applies to a command AST
    $cmdAst = $_ -as [Management.Automation.Language.CommandAst]
    if (-not $cmdAst) { return $false }
    # It must have at 4-5 elements.
    if ($cmdAst.CommandElements.Count -lt 4 -or $cmdAst.CommandElements.Count -gt 5) {
        return $false
    }
    # The second element must be a function or filter.
    if ($cmdAst.CommandElements[1].Value -notin 'function', 'filter') {
        return $false
    }
    # The third element must be a bareword
    if ($cmdAst.CommandElements[1].StringConstantType -ne 'Bareword') {
        return $false
    }

    # The last element must be a ScriptBlock
    if ($cmdAst.CommandElements[-1] -isnot [Management.Automation.Language.ScriptBlockExpressionAst]) {
        return $false
    }

    # Attempt to resolve the command
    $resolvedCommand = $executionContext.SessionState.InvokeCommand.GetCommand($cmd.CommandElements[0], 'All')
    if ($resolvedCommand) {
        # If it exists, return false.
        return $false
    }
    return $true
})]
param(
# The CommandAST that will be transformed.    
[Parameter(Mandatory,ValueFromPipeline)]
[Management.Automation.Language.CommandAst]
$CommandAst
)

process {
    # Namespaced functions are really simple:

    # We use multiple assignment to pick out the parts of the function
    $namespace, $functionType, $functionName, $functionDefinition = $CommandAst.CommandElements    

    # Then, we determine the last punctuation.
    $namespaceSeparatorPattern = [Regex]::new('[\p{P}<>]{1,}','RightToLeft')    
    $namespaceSeparator = $namespaceSeparatorPattern.Match($namespace).Value
    # If there was no punctuation, the namespace separator will be a '.'
    if (-not $namespaceSeparator) {$namespaceSeparator = '.'}
    # If the pattern was empty brackets `[]`, make the separator `[`.
    elseif ($namespaceSeparator -eq '[]') { $namespaceSeparator = '[' }
    # If the pattern was `<>`, make the separator `<`.
    elseif ($namespaceSeparator -eq '<>') { $namespaceSeparator = '<' }

    # Replace any trailing separators from the namespace.
    $namespace = $namespace -replace "$namespaceSeparatorPattern$"
    
    # Join the parts back together to get the new function name.
    $NewFunctionName = $namespace,$namespaceSeparator,$functionName,$(
        # If the namespace separator ends with `[` or `<`, try to close it
        if ($namespaceSeparator -match '[\[\<]$') {
            if ($matches.0 -eq '[') { ']' }
            elseif ($matches.0 -eq '<') { '>' }
        }
    ) -ne '' -join ''

    # Redefine the function
    $redefined = [ScriptBlock]::Create("
$functionType $NewFunctionName$functionDefinition
")
    # Return the transpiled redefinition.
    $redefined | .>Pipescript
}
