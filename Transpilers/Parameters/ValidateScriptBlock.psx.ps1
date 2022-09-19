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


[ValidateScript({
    $validTypeList = [System.String],[System.String[]],[System.Text.RegularExpressions.Regex],
        [Management.Automation.CommandInfo],[Management.Automation.CommandInfo[]]
    $thisType = $_.GetType()
    $IsTypeOk =
        $(@( foreach ($validType in $validTypeList) {
            if ($_ -as $validType) {
                $true;break
            }
        }))
    if (-not $isTypeOk) {
        throw "Unexpected type '$(@($thisType)[0])'.  Must be 'string','string[]','regex','commandinfo','commandinfo[]'."
    }
    return $true
})]
$IncludeCommand,

[ValidateScript({
    $validTypeList = [System.String],[System.String[]],[System.Text.RegularExpressions.Regex],
        [Management.Automation.CommandInfo],[Management.Automation.CommandInfo[]]
    $thisType = $_.GetType()
    $IsTypeOk =
        $(@( foreach ($validType in $validTypeList) {
            if ($_ -as $validType) {
                $true;break
            }
        }))
    if (-not $isTypeOk) {
        throw "Unexpected type '$(@($thisType)[0])'.  Must be 'string','string[]','regex','commandinfo','commandinfo[]'."
    }
    return $true
})]
$ExcludeCommand,

# If set, will ensure that the script block contains types in this list.
# Passing -IncludeType without -ExcludeType will make -ExcludeType default to *.
[ValidateScript({
$validTypeList = [System.String],[System.String[]],[System.Text.RegularExpressions.Regex],[System.Type],[System.Type[]]
$thisType = $_.GetType()
$IsTypeOk =
    $(@( foreach ($validType in $validTypeList) {
        if ($_ -as $validType) {
            $true;break
        }
    }))
if (-not $isTypeOk) {
    throw "Unexpected type '$(@($thisType)[0])'.  Must be 'string','string[]','regex','type','type[]'."
}
return $true
})]
$IncludeType,

# If set, will ensure that the script block does not use the types in this list.
# Passing -IncludeType without -ExcludeType will make -ExcludeType default to *.
[ValidateScript({
$validTypeList = [System.String],[System.String[]],[System.Text.RegularExpressions.Regex],[System.Type],[System.Type[]]
$thisType = $_.GetType()
$IsTypeOk =
    $(@( foreach ($validType in $validTypeList) {
        if ($_ -as $validType) {
            $true;break
        }
    }))
if (-not $isTypeOk) {
    throw "Unexpected type '$(@($thisType)[0])'.  Must be 'string','string[]','regex','type','type[]'."
}
return $true
})]
$ExcludeType,

# If set, will ensure that the ScriptBlock does not contain any loops.
[Alias('NoLoops')]
[switch]
$NoLoop,

# If set, will ensure that the ScriptBlock does not contain any do or while loops.
[Alias('NoWhileLoops','NoDoLoops','NoDoLoop')]
[switch]
$NoWhileLoop,

# One or more AST conditions to validate.
# If no results are found or the condition throws, the script block will be considered invalid.
[Alias('AstConditions', 'IfAst')]
[Scriptblock[]]
$AstCondition,

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

    # If -IncludeCommand or -ExcludeCommand were provided
    # generate an -ASTCondition to check command inclusion.
    if ($IncludeCommand -or $ExcludeCommand) {        
        if (-not $ExcludeCommand) {
            $ExcludeCommand = '*'
        }
        
        if (-not $IncludeCommand -and $ExcludeCommand -eq '*') {
            $AstCondition += {
param($ast)
if ($ast -is [Management.Automation.Language.CommandAst]) {
    throw "AST cannot contain commands"
}
return $true}
        }
        else {
            $AstCondition += [ScriptBlock]::Create(@"
param(`$ast)
`$included = $(
    if (-not $IncludeCommand) { '$null' }
    @($(foreach ($inc in $IncludeCommand) {
    if ($inc -is [string]) {
        "'$($inc -replace "'","''")'"
    }
    elseif ($inc -is [Management.Automation.CommandInfo]) {
        "'$($inc.Name -replace "'","''")'"
    }
    elseif ($inc -is [regex]) {
        "[Regex]::new('$($inc.ToString().Replace("'","''"))','$($inc.Options)','$($inc.MatchTimeout)')"
    }
})) -join ',')
`$excluded = $(@(
    if (-not $ExcludeCommand) { '$null' }
    $(foreach ($exc in $ExcludeCommand) {
    if ($exc -is [string]) {
        "'$($exc -replace "'","''")'"
    }
    elseif ($exc -is [Management.Automation.CommandInfo]) {
        "'$($exc.Name -replace "'","''")'"
    }
    elseif ($exc -is [regex]) {
        "[Regex]::new('$($exc.ToString().Replace("'","''"))','$($exc.Options)','$($exc.MatchTimeout)')"
    }
})) -join ',')
if (`$ast -is [Management.Automation.Language.CommandAst]) {
    `$astCommandName = `$ast.CommandElements[0].Value
$(if ($IncludeCommand) {
{
    foreach ($inc in $included) {
        if ($inc -is [string] -and $astCommandName -like $inc) {
            return $true
        }
        elseif ($inc -is [Regex] -and $astCommandName -match $inc) {
            return $true
        }        
    }
}})
$({
    $throwMessage = "$astCommandName is not allowed" 
    foreach ($exc in $excluded) {
        if ($exc -is [string] -and $astCommandName -like $exc) {
            throw $throwMessage
        }
        elseif ($exc -is [regex] -and $astCommandName -match $exc) {
            throw $throwMessage
        }        
    }
})

}
return `$true
"@)
        }
    }

    # If -IncludeType or -ExcludeType were provided
    if ($IncludeType -or $ExcludeType) {        
        if (-not $ExcludeType) {
            $ExcludeType = '*'
        }
        
        if (-not $IncludeType -and $ExcludeType -eq '*') {
            $AstCondition += {
param($ast)
if ($ast -is [Management.Automation.Language.TypeExpressionAst]) {
    throw "AST cannot contain types"
}
return $true}
        }
        else {
            $AstCondition += [ScriptBlock]::Create(@"
param(`$ast)
`$included = $(
    if (-not $IncludeType) { '$null' }
    @($(foreach ($incT in $IncludeType) {
    if ($incT -is [string]) {
        "'$($incT -replace "'","''")'"
    }
    elseif ($incT -is [type]) {
        "[$($incT.FullName -replace '^System\.')]"
    }
    elseif ($incT -is [regex]) {
        "[Regex]::new('$($incT.ToString().Replace("'","''"))','$($incT.Options)','$($incT.MatchTimeout)')"
    }
})) -join ',')
`$excluded = $(@(
    if (-not $ExcludeType) { '$null' }
    $(foreach ($excT in $ExcludeType) {
    if ($excT -is [string]) {
        "'$($excT -replace "'","''")'"
    }
    elseif ($excT -is [type]) {
        "[$($excT.FullName -replace '^System\.')]"
    }
    elseif ($excT -is [regex]) {
        "[Regex]::new('$($excT.ToString().Replace("'","''"))','$($excT.Options)','$($excT.MatchTimeout)')"
    }
})) -join ',')
if (`$ast -is [Management.Automation.Language.TypeExpressionAst]) {
$(if ($IncludeType) {
{
    foreach ($inc in $included) {
        if ($inc -is [string] -and $ast.TypeName -like $inc) {
            return $true
        }
        elseif ($inc -is [Regex] -and $ast.TypeName -match $inc) {
            return $true
        }
        elseif ($inc -is [type]){
            $reflectionType = $ast.TypeName.GetReflectionType()
            if ($inc -eq $reflectionType) { return $true}
            if ($inc.IsSubclassOf($reflectionType) -or $reflectionType.IsSubclassOf($inc)) {
                return $true
            }
            if ($inc.IsInterface -and $reflectionType.getInterFace($inc)) {
                return $true
            }
            if ($reflectionType.IsInterface -and $inc.getInterFace($reflectionType)) {
                return $true
            }            
        }
    }
}})
$({
    $throwMessage = "[$($ast.Typename)] is not allowed" 
    foreach ($exc in $excluded) {
        if ($exc -is [string] -and $ast.TypeName -like $exc) {
            throw $throwMessage
        }
        elseif ($exc -is [regex] -and $ast.TypeName -match $exc) {
            throw $throwMessage
        }
        elseif ($exc -is [type]) {
            $reflectionType = $ast.TypeName.GetReflectionType()
            if ($ecx -eq $reflectionType) { 
                throw $throwMessage
            }
            elseif ($exc.IsSubclassOf($reflectionType) -or $reflectionType.IsSubclassOf($exc)) {
                throw $throwMessage
            }
            elseif ($exc.IsInterface -and $reflectionType.getInterFace($exc)) {
                throw $throwMessage
            }
            elseif ($reflectionType.IsInterface -and $exc.getInterFace($reflectionType)) {
                throw $throwMessage
            }            
        }
    }
})

}
return `$true
"@)
        }
    }

    if ($NoLoop) {
        $AstCondition += {
param($ast)
if ($ast -is [Management.Automation.Language.LoopStatementAst]) {
    throw "ScriptBlock cannot contain loops"
}
return $true
}
    } elseif ($NoWhileLoop) {
        $AstCondition += {
param($ast)
if ($ast -is [Management.Automation.Language.LoopStatementAst] -and 
    $ast.GetType().Name -match '(?>do|while)') {
    throw "ScriptBlock cannot contain $($ast.GetType().Name)"
}
}
    }
    
    if ($AstCondition) {
@"
[ValidateScript({
    if (`$_ -isnot [ScriptBlock]) { return `$true }    
    `$astConditions = {$($AstCondition -join '} , {')}
    `$scriptBlockAst = `$_.Ast
    foreach (`$astCondition in `$astConditions) {
        `$foundResults = `$scriptBlockAst.FindAll(`$astCondition, `$true)
        if (-not `$foundResults) { return `$false}
    }
    return `$true    
})]
"@
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
