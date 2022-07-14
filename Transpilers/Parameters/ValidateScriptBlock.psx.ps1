<#
.SYNOPSIS
    Validates Script Blocks
.DESCRIPTION
    Validates Script Blocks for a number of common scenarios.
.EXAMPLE
    {
        param(
        [ValidateScriptBlock(Safe)]
        [ScriptBlock]
        $ScriptBlock
        )

        $ScriptBlock
    } | .>PipeScript
.EXAMPLE
    {
        param(
        [ValidateScriptBlock(NoBlock,NoParameters)]
        [ScriptBlock]
        $ScriptBlock
        )

        $ScriptBlock
    } | .>PipeScript
.EXAMPLE
    {
        param(
        [ValidateScriptBlock(OnlyParameters)]
        [ScriptBlock]
        $ScriptBlock
        )

        $ScriptBlock
    } | .>PipeScript
#>
[CmdletBinding(DefaultParameterSetName='Parameter')]
param(
# If set, will validate that ScriptBlock is "safe".
# This will attempt to recreate the Script Block as a datalanguage block and execute it.
[Alias('Safe')]
[switch]
$DataLanguage,

# If set, will ensure that the [ScriptBlock] only has parameters
[Alias('OnlyParameters')]
[switch]
$ParameterOnly,

# If set, will ensure that the [ScriptBlock] has no named blocks.
[Alias('NoBlocks')]
[switch]
$NoBlock,

# If set, will ensure that the [ScriptBlock] has no parameters.
[Alias('NoParameters','NoParam')]
[switch]
$NoParameter,

# A VariableExpression.  If provided, the Validation attributes will apply to this variable.
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='VariableExpressionAST')]
[Management.Automation.Language.VariableExpressionAST]
$VariableAST
)

process {

$validateScripts = @(
    if ($DataLanguage) {
@'
[ValidateScript({
    if ($_ -isnot [ScriptBlock]) { return $true }
    $sbCopy = "data { $_ }"
    try {
        $dataOutput = & ([ScriptBlock]::Create($sbCopy))
        return $true
    } catch {
        throw    
    }
})]
'@
    }
    if ($ParameterOnly) {
@'
[ValidateScript({
    if ($_ -isnot [ScriptBlock]) { return $true }
    $statementCount = 0
    $statementCount += $_.Ast.DynamicParamBlock.Statements.Count
    $statementCount += $_.Ast.BeginBlock.Statements.Count
    $statementCount += $_.Ast.ProcessBlock.Statements.Count
    $statementCount += $_.Ast.EndBlock.Statements.Count
    if ($statementCount) {
        throw "ScriptBlock should have no statements"
    } else { 
        return $true
    }
})]
'@
    }
    if ($NoBlock) {
@'
[ValidateScript({
    if ($_ -isnot [ScriptBlock]) { return $true }
    if ($_.Ast.DynamicParamBlock -or $_.Ast.BeginBlock -or $_.Ast.ProcessBlock) {
        throw "ScriptBlock should not have any named blocks"
    }
    return $true    
})]
'@        
    }
    if ($NoParameter) {
@'
[ValidateScript({
    if ($_ -isnot [ScriptBlock]) { return $true }
    if ($_.Ast.ParamBlock.Parameters.Count) {
        throw "ScriptBlock should not have parameters"
    }
    return $true    
})]
'@
    }    
)
    if (-not $validateScripts) { return }

    [scriptblock]::Create(@"
$($validateScripts -join [Environment]::NewLine)$(
    if ($psCmdlet.ParameterSetName -eq 'Parameter') {
        'param()'
    } else {
        '$' + $VariableAST.variablePath.ToString()
    }
)
"@.Trim())


}
