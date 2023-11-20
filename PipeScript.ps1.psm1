[Include('*-*')]$psScriptRoot

$transpilerNames = @(@(Get-Transpiler).DisplayName) -ne ''

$aliasList +=
    [SmartAlias(Command='Use-PipeScript',Prefix='.>',PassThru)]$transpilerNames

$aliasList +=
    [SmartAlias(Command='Use-PipeScript',Prefix='.<',Suffix='>',PassThru)]$transpilerNames

$pipeScriptKeywords = @(
    foreach ($transpiler in Get-Transpiler) {
        if ($transpiler.Metadata.'PipeScript.Keyword' -and $transpiler.DisplayName) {
            $transpiler.DisplayName
        }
    }
)    

$aliasList +=
    [SmartAlias(Command='Use-PipeScript',PassThru)]$pipeScriptKeywords

$MyModule = $MyInvocation.MyCommand.ScriptBlock.Module
$aliasList +=
    [GetExports("Alias")]$MyModule

try {
    $ExecutionContext.SessionState.PSVariable.Set(
        $MyInvocation.MyCommand.ScriptBlock.Module.Name,
        $MyInvocation.MyCommand.ScriptBlock.Module
    )
} catch {
    # There is the slimmest of chances we might not be able to set the variable, because it was already constrained by something else.
    # If this happens, we still want to load the module, and we still want to know, so put it out to Verbose.
    Write-Verbose "Could not assign module variable: $($_ | Out-String)"
}

Export-ModuleMember -Function * -Alias * -Variable $MyInvocation.MyCommand.ScriptBlock.Module.Name

Update-TypeData -AppendPath (Join-Path $psScriptRoot "PipeScript.types.ps1xml")

$CommandNotFoundAction = {
    param($sender, $eventArgs)

    # Rather than be the only thing that can handle command not found, we start by broadcasting an event.
    $null = New-Event -SourceIdentifier "PowerShell.CommandNotFound"  -MessageData $notFoundArgs -Sender $global:ExecutionContext -EventArguments $notFoundArgs
    
    # Then we determine our own script block.
    $myScriptBlock = $MyInvocation.MyCommand.ScriptBlock
    # Then, we do a bit of callstack peeking
    $callstack = @(Get-PSCallStack)
    $myCallCount = 0
    foreach ($call in $callstack) {
        if ($call.InvocationInfo.MyCommand.ScriptBlock -eq $myScriptBlock) {
            $myCallCount++
        }
    }

    # If we're being called more than once
    if ($myCallCount -gt 1) {        
        return # we're done.
    }

    $callstackPeek = $callstack[-1]
    # When peeking in on a dynamic script block, the offsets may lie.
    $column = [Math]::Max($callstackPeek.InvocationInfo.OffsetInLine, 1)
    $line   = [Math]::Max($callstackPeek.InvocationInfo.ScriptLineNumber, 1)
    $callingScriptBlock = $callstackPeek.InvocationInfo.MyCommand.ScriptBlock
    # Now find all of the AST elements at this location.
    $astFound  = @($callingScriptBlock.Ast.FindAll({
        param($ast)
        $ast.Extent.StartLineNumber -eq $line -and
        $ast.Extent.StartColumnNumber -eq $column
    }, $true))
    if (-not $script:LastCommandNotFoundScript) {
        $script:LastCommandNotFoundScript = $callingScriptBlock
    } elseif ($script:LastCommandNotFoundScript -eq $callingScriptBlock) {
        return
    } else {
        $script:LastCommandNotFoundScript = $callingScriptBlock
    }

    if (-not $callingScriptBlock) {
        return
    }

    
    $transpiledScriptBlock = 
        try {
            $callingScriptBlock.Transpile()
        } catch {
            Write-Error $_
            return
        }
    if ($transpiledScriptBlock -and 
        ($transpiledScriptBlock.ToString().Length -ne $callingScriptBlock.ToString().Length)) {
        
        $endStatements = $transpiledScriptBlock.Ast.EndBlock.Statements
        $FirstExpression = 
            if ($endStatements -and (
                $endStatements[0] -is 
                    [Management.Automation.Language.PipelineAst]
                ) -and (                    
                $endStatements[0].PipelineElements[0] -is 
                    [Management.Automation.Language.CommandExpressionAst]
                )
            ) {
                $endStatements[0].PipelineElements[0].Expression
            } else { $null }
            
        if ($astFound -and 
            $astFound[-1].Parent -is [Management.Automation.Language.AssignmentStatementAst] -and
            (
                $FirstExpression -is [Management.Automation.Language.BinaryExpressionAst] -or
                $FirstExpression -is [Management.Automation.Language.ParenExpressionAst]
            )
        ) {
            Write-Error "
Will not interactively transpile {$callingScriptBlock} ( because it would overwrite $($astFound[-1].Parent.Left.Extent) )"
            return
        }

        if ($astFound -and 
            $astFound[-1].Parent -is [Management.Automation.Language.AssignmentStatementAst] -and
            $endStatements -and 
            $endStatements[0] -is [Management.Automation.Language.AssignmentStatementAst] -and 
            $astFound[-1].Parent.Left.ToString() -eq $endStatements[0].Left.ToString()) {
            $eventArgs.CommandScriptBlock = [ScriptBlock]::Create($endStatements[0].Right.ToString())
            $eventArgs.StopSearch = $true
        } else {
            $eventArgs.CommandScriptBlock = $transpiledScriptBlock
            $eventArgs.StopSearch = $true
        }                            
    }

    return    
}

$global:ExecutionContext.SessionState.InvokeCommand.CommandNotFoundAction = $CommandNotFoundAction

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    $global:ExecutionContext.SessionState.InvokeCommand.CommandNotFoundAction = $null
}
