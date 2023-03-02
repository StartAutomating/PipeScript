foreach ($file in (Get-ChildItem -Path "$psScriptRoot" -Filter "*-*" -Recurse)) {
    if ($file.Extension -ne '.ps1')      { continue }  # Skip if the extension is not .ps1
    if ($file.Name -match '\.[^\.]+\.ps1$') { continue }  # Skip if the file is an unrelated file.
    . $file.FullName
}

$transpilerNames = Get-Transpiler | Select-Object -ExpandProperty DisplayName
$aliasList +=
    
    @(foreach ($alias in @($transpilerNames)) {
        Set-Alias ".>$alias" "Use-PipeScript" -PassThru:$True
    })
    

$aliasList +=
    
    @(foreach ($alias in @($transpilerNames)) {
        Set-Alias ".<$alias>" "Use-PipeScript" -PassThru:$True
    })
    

$pipeScriptKeywords = @(
    foreach ($transpiler in Get-Transpiler) {
        if ($transpiler.Metadata.'PipeScript.Keyword' -and $transpiler.DisplayName) {
            $transpiler.DisplayName
        }
    }
)    

$aliasList +=
    
    @(foreach ($alias in @($pipeScriptKeywords)) {
        Set-Alias "$alias" "Use-PipeScript" -PassThru:$True
    })
    

$MyModule = $MyInvocation.MyCommand.ScriptBlock.Module
$aliasList +=
    
    @(
    if ($MyModule -isnot [Management.Automation.PSModuleInfo]) {
        Write-Error "'$MyModule' must be a [Management.Automation.PSModuleInfo]"
    } elseif ($MyModule.ExportedCommands.Count) {
        foreach ($cmd in $MyModule.ExportedCommands.Values) {        
            if ($cmd.CommandType -in 'Alias') {
                $cmd
            }
        }
    } else {
        foreach ($cmd in $ExecutionContext.SessionState.InvokeCommand.GetCommands('*', 'Function,Cmdlet', $true)) {
            if ($cmd.Module -ne $MyModule) { continue }
            if ('Alias' -contains 'Alias' -and $cmd.ScriptBlock.Attributes.AliasNames) {
                foreach ($aliasName in $cmd.ScriptBlock.Attributes.AliasNames) {
                    $ExecutionContext.SessionState.InvokeCommand.GetCommand($aliasName, 'Alias')
                }
            }
            if ('Alias' -contains $cmd.CommandType) {
                $cmd
            }
        }
    })
    

Export-ModuleMember -Function * -Alias $aliasList

$global:ExecutionContext.SessionState.InvokeCommand.CommandNotFoundAction = {
    param($sender, $eventArgs)

    # Rather than be the only thing that can handle command not found, we start by broadcasting an event.
    New-Event -SourceIdentifier "PowerShell.CommandNotFound"  -MessageData $notFoundArgs -Sender $global:ExecutionContext -EventArguments $notFoundArgs
    
    # Then, we do a bit of callstack peeking
    $callstack = @(Get-PSCallStack)
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

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    $global:ExecutionContext.SessionState.InvokeCommand.CommandNotFoundAction = $null
}
