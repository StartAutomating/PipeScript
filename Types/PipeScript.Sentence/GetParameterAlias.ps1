<#
.SYNOPSIS
    Gets a parameter's alias
.DESCRIPTION
    Gets the alias used to call a parameter in a sentence.

    This can be useful for inferring subtle differences based off of word choice, as in

    `all functions matching Sentence` # Returns all functions that match Sentence

    Compared to:

    `all functions where Sentence` # Returns all functions that are Sentences            
.EXAMPLE
    {* pid $pid}.Ast.EndBlock.Statements[0].PipelineElements[0].AsSentence((Get-Command Get-Process)).GetParameterAlias('id')
#>
param(
# The name of one or more parameters.
[string[]]
$Parameter
)

$parameterWildcards = $Parameter -match '[\*\?]'

@(:nextClause foreach ($sentenceClause in $this.Clauses) {
    if (-not $sentenceClause.ParameterName) { continue }
    
    if ($parameter -contains $sentenceClause.ParameterName) {
        $sentenceClause.Name
    }
    elseif ($parameterWildcards) {
        foreach ($wildcard in $parameterWildcards) {
            if ($sentenceClause.ParameterName -like $wildcard) {
                $sentenceClause.Name
                continue nextClause
            }
        }
    }
})