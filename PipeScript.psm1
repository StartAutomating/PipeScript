:ToIncludeFiles foreach ($file in (Get-ChildItem -Path "$psScriptRoot" -Filter "*-*" -Recurse)) {
    if ($file.Extension -ne '.ps1')      { continue }  # Skip if the extension is not .ps1
    foreach ($exclusion in '\.[^\.]+\.ps1$') {
        if (-not $exclusion) { continue }
        if ($file.Name -match $exclusion) {
            continue ToIncludeFiles  # Skip excluded files
        }
    }     
    . $file.FullName
}

$transpilerNames = @(@(Get-Transpiler).DisplayName) -ne ''

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
    



try {
    $ExecutionContext.SessionState.PSVariable.Set(
        $MyModule.Name,
        $MyModule
    )
} catch {
    # There is the slimmest of chances we might not be able to set the variable, because it was already constrained by something else.
    # If this happens, we still want to load the module, and we still want to know, so put it out to Verbose.
    Write-Verbose "Could not assign module variable: $($_ | Out-String)"
}

# If New-PSDrive exists
if ($ExecutionContext.SessionState.InvokeCommand.GetCommand('New-PSDrive', 'Cmdlet')) {    
    try {
        # mount the module as a drive
        New-PSDrive -Name $MyModule.Name -PSProvider FileSystem -Root ($MyModule.Path | Split-Path) -Description $MyModule.Description -Scope Global -ErrorAction Ignore
    } catch {
        Write-Verbose "Could not add drive: $($_ | Out-String)"
    }    
}

$typesFilePath = (Join-Path $psScriptRoot "PipeScript.types.ps1xml")
Update-TypeData -AppendPath $typesFilePath

$typesXmlNoteProperties = Select-Xml -Path $typesFilePath -XPath '//NoteProperty'
$typeAccelerators = [psobject].assembly.gettype("System.Management.Automation.TypeAccelerators")

foreach ($typesXmlNoteProperty in $typesXmlNoteProperties){
    if ($typesXmlNoteProperty.Node.Name -notmatch '\.class\.ps1$') {
        continue
    }

    $classScriptBlock =  
        try {
            ([scriptblock]::create($typesXmlNoteProperty.Node.Value))

        } catch {
            Write-Warning "Could not define '$($typesXmlNoteProperty.Node.Name)': $($_ | Out-String)"
        }

    if (-not $classScriptBlock) { continue }
    
    $typeDefinitionsAst = $classScriptBlock.Ast.FindAll({param($ast) $ast -is [Management.Automation.Language.TypeDefinitionAst]}, $true)
    if (-not $typeDefinitionsAst) { continue }
    . $classScriptBlock
    foreach ($typeDefinitionAst in $typeDefinitionsAst) {
        $resolvedType = $typeDefinitionAst.Name -as [type]
        if (-not $resolvedType) { continue }
        $typeAccelerators::Add("$($MyModule.Name).$($typeDefinitionAst.Name)", $resolvedType)
        $typeAccelerators::Add("$($typeDefinitionAst.Name)", $resolvedType)
    }    
}

# A few extension types we want to publish as variables
$PipeScript.Extensions | 
    . { 
        begin {
            # Languages will populate `$psLanguage(s)`
            $LanguagesByName = [Ordered]@{}

            # Interpreters will populate `$psInterpreter(s)`
            $InterpretersByName = [Ordered]@{}

            # Parsers will populate `$psParsers`
            $ParsersByName = [Ordered]@{}           
        }
        process {            
            if ($_.Name -notlike 'Language*') { 
                if ($_.pstypenames -contains 'Parser.Command') {
                    $ParsersByName[$_.Name] = $_
                }
                return
            }
            $languageObject = & $_
            if (-not $languageObject.LanguageName) {
                return
            }
            $LanguagesByName[$languageObject.LanguageName] = $languageObject
            if ($languageObject.Interpreter) {
                $InterpretersByName[$languageObject.LanguageName] = $languageObject
            }
        }

        end {        
            $PSLanguage = $PSLanguages = [PSCustomObject]$LanguagesByName
            $PSLanguage.pstypenames.clear()
            $PSLanguage.pstypenames.insert(0,'PipeScript.Languages')
            
            $PSInterpreter = $PSInterpreters = [PSCustomObject]$InterpretersByName
            $PSInterpreter.pstypenames.clear()
            $PSInterpreter.pstypenames.insert(0,'PipeScript.Interpreters')

            $PSParser = $PSParsers = [PSCustomObject]$ParsersByName
            $PSParser.pstypenames.clear()
            $PSParser.pstypenames.insert(0,'PipeScript.Parsers')
        }
    }

Export-ModuleMember -Function * -Alias * -Variable $MyInvocation.MyCommand.ScriptBlock.Module.Name, 
    'PSLanguage', 'PSLanguages', 
    'PSInterpreter', 'PSInterpreters',
    'PSParser','PSParsers'

$PreCommandAction = {
    param($LookupArgs)

    if (-not $global:NewModule -or -not $global:ImportModule) {
        $global:ImportModule, $global:NewModule = 
            $global:ExecutionContext.SessionState.InvokeCommand.GetCommands('*-Module', 'Cmdlet', $true) -match '^(?>New|Import)'
    }
    
    if (-not $global:AllFunctionsAndAliases) {
        $global:AllFunctionsAndAliases =
            $global:ExecutionContext.SessionState.InvokeCommand.GetCommands('*', 'Alias,Function', $true)
    }
    
    $invocationName = $LookupArgs
    if ($PSInterpreters) {
        $interpreterForName = $PSInterpreters.ForFile($invocationName)
        
        if ($interpreterForName -and 
            -not ($global:AllFunctionsAndAliases -match $([Regex]::Escape($invocationName)))) {
            foreach ($maybeInterprets in $interpreterForName) {                                    
                $adHocModule = & $newModule -ScriptBlock (
                    [ScriptBlock]::Create(
                        @(
                            "Set-Alias '$($invocationName -replace "'","''")' 'Invoke-Interpreter'"
                            "Export-ModuleMember -Alias *"
                        ) -join ';'
                    )
                ) -Name @($invocationName -split '[\\/]')[-1] | & $importModule -Global -PassThru
                $null = New-Event -SourceIdentifier "PipeScript.Interpreter.Found" -Sender $maybeInterprets -EventArguments $adHocModule, $invocationName -MessageData $adHocModule, $invocationName
                return $invocationName
            }
        }        
    }
}

$global:ExecutionContext.InvokeCommand.PreCommandLookupAction = $PreCommandAction

$CommandNotFoundAction = {
    param($sender, $eventArgs)

    # Rather than be the only thing that can handle command not found, we start by broadcasting an event.
    $null = New-Event -SourceIdentifier "PowerShell.CommandNotFound"  -MessageData $eventArgs -Sender $sender -EventArguments $eventArgs
    
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
    $global:ExecutionContext.SessionState.InvokeCommand.PreCommandLookupAction = $null
}

