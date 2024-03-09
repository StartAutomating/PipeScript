function Invoke-PipeScript {
    <#
    .SYNOPSIS
        Invokes PipeScript or PowerShell ScriptBlocks, commands, and syntax.
    .DESCRIPTION
        Runs PipeScript.

        Invoke-PipeScript can run any PowerShell or PipeScript ScriptBlock or Command.

        Invoke-PipeScript can accept any -InputObject, -Parameter(s), and -ArgumentList.

        These will be passed down to the underlying command.

        Invoke-PipeScript can also use a number of Abstract Syntax Tree elements as command input:

        |AST Type                 |Description                            |
        |-------------------------|---------------------------------------|
        |AttributeAST             |Runs Attributes                        |
        |TypeConstraintAST        |Runs Type Constraints                  |        
    .LINK
        Use-PipeScript
    .LINK
        Update-PipeScript
    .EXAMPLE
        # PipeScript is a superset of PowerShell.
        # So a hello world in PipeScript is the same as a "Hello World" in PowerShell:

        Invoke-PipeScript { "hello world" } # Should -Be "Hello World"
    .EXAMPLE
        # Invoke-PipeScript will invoke a command, ScriptBlock, file, or AST element as PipeScript.
        Invoke-PipeScript { all functions } # Should -BeOfType ([Management.Automation.FunctionInfo])
    #>
    [CmdletBinding(PositionalBinding=$false)]
    [Alias('ips', '.>')]
    param(
    # The input object.  This will be piped into the underlying command.
    # If no -Command is provided and -InputObject is a [ScriptBlock]
    [Parameter(ValueFromPipeline)]
    [PSObject]
    $InputObject,

    # The Command that will be run.
    [ValidateScript({
        $PotentialCommand = $_
        if ($null -eq $PotentialCommand)         { return $false }
        if ($PotentialCommand -is [ScriptBlock]) { return $true }
        if ($PotentialCommand -is [string])      { return $true }
        if ($PotentialCommand -is [Management.Automation.CommandInfo]) { return $true }
        if ($PotentialCommand.GetType().Namespace -eq 'System.Management.Automation.Language' -and
            $PotentialCommand.GetType().Name -in 'AttributeAST', 'TypeConstraintAst','TypeExpressionAST') {
            return $true
        }

        return $false
    })]
    [Alias('ScriptBlock','CommandName', 'CommandInfo', 'AttributeSyntaxTree','TypeConstraint')]
    [Parameter(Position=0)]
    [PSObject]
    $Command,

    # A collection of named parameters.  These will be directly passed to the underlying script.
    [Alias('Parameters')]
    [Collections.IDictionary]
    $Parameter = [Ordered]@{},

    # A list of positional arguments.  These will be directly passed to the underlying script or command.
    [Parameter(ValueFromRemainingArguments)]
    [Alias('Arguments')]
    [PSObject[]]
    $ArgumentList = @(),

    # The OutputPath.
    # If no -OutputPath is provided and a template file is invoked, an -OutputPath will be automatically determined.
    # This currently has no effect if not invoking a template file.
    [string]
    $OutputPath,

    # If this is not set, when a transpiler's parameters do not take a [ScriptBlock], ScriptBlock values will be evaluated.
    # This can be a very useful capability, because it can enable dynamic transpilation.
    # If this is set, will make ScriptBlockAst values will be run within data language, which significantly limits their capabilities.
    [switch]
    $SafeScriptBlockAttributeEvaluation
    )

    begin {
        # First, check to see if we already cached a list of type accelerators
        if (-not $script:TypeAcceleratorsList) {
            # If we didn't, do that now.
            $script:TypeAcceleratorsList = [PSObject].Assembly.GetType("System.Management.Automation.TypeAccelerators")::Get.Keys
        }

        function TypeConstraintToArguments (
            [Parameter(ValueFromPipeline)]
            $TypeName
        ) {
            begin {
                $TypeNameArgs = @()
                $TypeNameParams = @{}
            }
            process {

                if ($TypeName.IsGeneric) {
                    $TypeNameParams[$typeName.Name] =
                        $typeName.GenericArguments |
                            TypeConstraintToArguments
                } elseif (-not $TypeName.IsArray) {
                    $TypeNameArgs += $TypeName.Name
                }
            }
            end {
                [PSCustomObject]@{
                    ArgumentList = $TypeNameArgs
                    Parameter    = $TypeNameParams
                }
            }
        }

    }

    process {
        $MyParameters = [Ordered]@{} + $psBoundParameters
        if ($InputObject -is [scriptblock] -and -not $psBoundParameters.ContainsKey('Command')) {
            $Command = $InputObject
            $InputObject = $null
            $null = $psBoundParameters.Remove('InputObject')
        }

        if ($InputObject -is [IO.FileInfo] -and -not $psBoundParameters.ContainsKey('Command')) {
            $Command = $ExecutionContext.SessionState.InvokeCommand.GetCommand($InputObject.FullName, 'All')
            $InputObject = $null
            $null = $psBoundParameters.Remove('InputObject')
        }

        if (-not $Command) {
            Write-Error "Must provide -Command, or pipe in a [ScriptBlock] or [IO.FileInfo]"
            return
        }

        $InvokePipeScriptParameters = [Ordered]@{} + $psBoundParameters
        $TranspilerErrors   = @()
        $TranspilerWarnings = @()
        $ErrorsAndWarnings  = @{ErrorVariable='TranspilerErrors';WarningVariable='TranspilerWarnings'}


        # If the command is a ```[ScriptBlock]```
        if ($Command -is [scriptblock])
        {
            # Attempt to transpile it.
            $TranspiledScriptBlock = $Command | .>Pipescript @ErrorsAndWarnings
            if (-not $TranspiledScriptBlock) {  # If we could not transpile it
                Write-Error "Command {$command} could not be transpiled" # error out.

                $null =
                    New-Event -SourceIdentifier 'PipeScript.Transpilation.Failed' -MessageData ([PSCustomObject][Ordered]@{
                        Command = $command
                        Error   = $TranspilerErrors
                        Warning = $TranspilerWarnings
                    })
                return
            }

            if ($TranspilerErrors) {
                $failedMessage = @(
                    "$($command.Source): " + "$($TranspilerErrors.Count) error(s)"
                    if ($transpilerWarnings) {
                        "$($TranspilerWarnings.Count) warning(s)"
                    }
                ) -join ','
                Write-Error $failedMessage -ErrorId Build.Failed -TargetObject (
                    [PSCustomObject][ordered]@{
                        Output     = $pipescriptOutput
                        Errors     = $TranspilerErrors
                        Warnings   = $TranspilerWarnings
                        Command    = $Command
                        Parameters = $InvokePipeScriptParameters
                    }
                )
            }

            # If it could not be transpiled into a [ScriptBlock] or [ScriptBlock[]]
            if ($TranspilerErrors -or
                ($transpiledScriptBlock -isnot [ScriptBlock] -and -not ($TranspiledScriptBlock -as [scriptblock[]]))) {
                # error out.
                Write-Error "Command {$command} could not be transpiled into [ScriptBlock]s"
                return
            }

            # Walk thru each resulting transpiled ScriptBlock
            foreach ($transpiledScript in $transpiledScriptBlock) {

                # If we had an input object
                if ($InputObject) {
                    # pipe it to the transpiled script.
                    $InputObject | & $transpiledScript @Parameter @ArgumentList
                } else {
                    # Otherwise, call the transpiled script.
                    & $transpiledScript @Parameter @ArgumentList
                }
            }
        }


        # If the command is a string,
        elseif ($Command -is [string])
        {
            # determine if it is the name of a command.
            $resolvedCommand = $ExecutionContext.SessionState.InvokeCommand.GetCommand($Command, 'All')
            # If it is, recursively reinvoke.
            if ($resolvedCommand) {
                $InvokePipeScriptParameters.Command = $resolvedCommand
                Invoke-PipeScript @InvokePipeScriptParameters
            } else {

                # If it was not a resolved command, attempt to create a [ScriptBlock].
                try {
                    $Command = [ScriptBlock]::Create($command)
                } catch {
                    $ex = $_  # If we could not, error out.
                    Write-Error "[string] -Command could not be made into a [ScriptBlock]: $ex"
                    return
                }

                # If we could, recursively reinvoke.
                if ($command -is [ScriptBlock]) {
                    $InvokePipeScriptParameters.Command = $command
                    Invoke-PipeScript @InvokePipeScriptParameters
                }
            }
        }


        # If the command is a ```[Management.Automation.CommandInfo]```
        elseif ($command -is [Management.Automation.CommandInfo])
        {
            # Determine if the Command is a Template File.
            $IsTemplateFile = '\.ps1{0,1}\.(?<ext>[^.]+$)' # if it matches the regex designating a SourceGenerator

            $pipeScriptLanguages = Get-PipeScript -PipeScriptType Language
            $matchingPipeScriptLanguage = $(foreach ($pipescriptLanguage in $pipeScriptLanguages) {                    
                if ($pipescriptLanguage.IsMatch($Command)) {
                    $matchingPipeScriptLanguageCommand = $pipescriptLanguage
                    & $pipescriptLanguage
                    break
                }
            })

            # If the command was not a source generator we'll try to invoke it.
            if ($Command.Source -notmatch $IsTemplateFile ) {                
                # If we have an interpreter for that language we'll want to run it.
                if ($matchingPipeScriptLanguage.Interpreter -or $matchingPipeScriptLanguage.Runner) {                    
                    # Rather than duplicate a lot of code, the easiest way to do this is simply to alias the full path                    
                    Set-Alias $command.Source Invoke-Interpreter
                    # and reset the value of $Command
                    $command = $ExecutionContext.SessionState.InvokeCommand.GetCommand($command.Source, 'Alias')
                    # (the alias will only exist locally, and not exist when Invoke-PipeScript returns)
                }
                
                $CommandStart = [DateTime]::now
                if ($InputObject) {
                    $InputObject | & $Command @Parameter @ArgumentList
                } else {
                    & $Command @Parameter @ArgumentList
                }
                $CommandEnd = [DateTime]::Now
                $null = New-Event -SourceIdentifier 'PipeScript.Command.Completed' -MessageData ([PSCustomObject]([Ordered]@{
                    Command = $Command
                    Parameter = $Parameter
                    ArgumentList = $ArgumentList
                    InputObject = $InputObject
                    Duration    = $CommandEnd - $CommandStart
                    Status = $?
                }  + $(if ($DebugPreference -notin 'silentlycontinue', 'ignore') {
                    @{Callstack=Get-PSCallStack}
                } else {
                    @{}
                })))
            }

            # If the command was a source generator
            else {
                if (-not $MyParameters.OutputPath) {
                    # predetermine the output path if none was provided.
                    $outputPath = $($Command.Source -replace $IsTemplateFile, '.${ext}')
                }
                            
                if (-not $script:CoreTemplateTranspiler) {
                    $script:CoreTemplateTranspiler = Get-Transpiler -TranspilerName PipeScript.Template
                }                                                

                $ParamsAndArgs    = [Ordered]@{Parameter=$Parameter;ArgumentList = $ArgumentList}
                $transpilerErrors   = @()
                $transpilerWarnings = @()

                # Push into the location of the file, so the current working directory will be accurate for any inline scripts.
                Push-Location ($command.Source | Split-Path)

                # Get the output from the source generator.
                $pipescriptOutput =                     
                    if (
                        $matchingPipeScriptLanguage.StartPattern -and 
                        $matchingPipeScriptLanguage.EndPattern
                    ) {
                        $templateName = ($command.Source | Split-Path -Leaf) -replace '[\s\p{Ps}]\(\)]' -replace '\.ps1?'

                        $CoreTemplateTranspilerSplat = [Ordered]@{SourceText=[IO.File]::ReadAllText($command.Source)}
                        if ($ArgumentList) {
                            $CoreTemplateTranspilerSplat.ArgumentList = $ArgumentList
                        }
                        if ($parameter) {
                            $CoreTemplateTranspilerSplat.Parameter = $Parameter
                        }
                        foreach ($prop in $matchingPipeScriptLanguage.psobject.properties) {
                            if ($script:CoreTemplateTranspiler.Parameters[$prop.Name]) {
                                $CoreTemplateTranspilerSplat[$prop.Name] = $prop.Value
                            }
                        }

                        $approveTemplateEvent =
                            New-Event -SourceIdentifier 'PipeScript.TemplateFile.Approve' -MessageData ([PSCustomObject][Ordered]@{
                                Language = $matchingPipeScriptLanguage
                                TemplateFilePath = $command.Source
                            }) -EventArguments $MatchingPipeScriptLanguage, $command.Source
                        
                        Out-Null # Running nothing, so that events have a chance to process
                        $denyTemplateEvents = @(Get-Event -SourceIdentifier 'PipeScript.TemplateFile.Deny' -ErrorAction Ignore)
                        if ($denyTemplateEvents) {
                            [Array]::Reverse($denyTemplateEvents)
                            $denyThisFile = 
                                foreach ($denyEvent in $denyTemplateEvents) {
                                    if ($denyEvent.MessageData.TemplateFilePath -eq 
                                        $approveTemplateEvent.MessageData.TemplateFilePath -and 
                                        $denyEvent.TimeGenerated -gt $approveTemplateEvent.TimeGenerated) {
                                        $true;break
                                    }
                                    if ($denyEvent.TimeGenerated -lt $approveTemplateEvent.TimeGenerated) {
                                        break
                                    }
                                }
                            if ($denyThisFile) { return }
                        }
                        
                        $templateOutput = & $script:CoreTemplateTranspiler @CoreTemplateTranspilerSplat @ErrorsAndWarnings
                        $null =
                                New-Event -SourceIdentifier 'PipeScript.TemplateFile.Out' -MessageData ([PSCustomObject][Ordered]@{
                                    Language         = $matchingPipeScriptLanguage
                                    TemplateFilePath = $command.Source
                                    Output     = $templateOutput
                                    Errors     = $TranspilerErrors
                                    Warnings   = $TranspilerWarnings
                                }) -EventArguments $MatchingPipeScriptLanguage, $command.Source
                        if ($matchingPipeScriptLanguage.ReplaceOutputFileName) {
                            # This is a little annoying and esoteric, but it's required to make something like a "Dockerfile" work.
                            $OutputPath = $OutputPath | Split-Path | Join-Path -ChildPath (
                                ($OutputPath | Split-Path -Leaf) -replace $matchingPipeScriptLanguage.ReplaceOutputFileName
                            )
                        }
                        if ($templateOutput) {
                            $templateOutput | Set-Content -Path $OutputPath
                            Get-Item -Path $OutputPath
                        }                                            
                    }
                    else {
                        # If we did not find a transpiler, treat the source code as PipeScript/PowerShell.
                        $fileScriptBlock =
                            # If there was no .ScriptBlock on the command.
                            if (-not $Command.ScriptBlock) {
                                # read the file as text
                                $fileText = [IO.File]::ReadAllText($Command.Source)
                                # and attempt to create a script block
                                try {
                                    [scriptblock]::Create($fileText) | .>Pipescript @ErrorsAndWarnings
                                } catch {
                                    $ex = $_
                                    Write-Error "[CommandInfo] -Command could not be made into a [ScriptBlock]: $ex"
                                }
                            } else {
                                $Command.ScriptBlock | .>Pipescript @ErrorsAndWarnings
                            }

                        if (-not $fileScriptBlock) { return }
                        if ($command.Source -match '\.psm{0,1}1{0,1}$') {
                            $fileScriptBlock
                        } else {
                            $InvokePipeScriptParameters.Command = $fileScriptBlock
                            Invoke-PipeScript @InvokePipeScriptParameters
                        }
                    }

                # Now that the source generator has finished running, we can Pop-Location.
                Pop-Location

                if ($TranspilerErrors) {
                    $failedMessage = @(
                        "$($command.Source): " + "$($TranspilerErrors.Count) error(s)"
                        if ($transpilerWarnings) {
                            "$($TranspilerWarnings.Count) warning(s)"
                        }
                    ) -join ','
                    
                    Write-Error $failedMessage -ErrorId Build.Failed -TargetObject (
                        [PSCustomObject][ordered]@{
                            Output     = $pipescriptOutput
                            Errors     = $TranspilerErrors
                            Warnings   = $TranspilerWarnings
                            Command    = $Command
                            Parameters = $InvokePipeScriptParameters
                        }
                    )
                    return
                }

                # If the source generator outputted a byte[]
                if ($pipeScriptOutput -as [byte[]]) {
                    # Save the content to $OutputPath as bytes.
                    [IO.File]::WriteAllBytes($outputPath, $pipescriptOutput -as [byte[]])
                    # Then output the file.
                    Get-Item -LiteralPath $outputPath
                }


                # If the source generator outputted file
                elseif ($pipeScriptOutput -is [IO.FileInfo]) {
                    # directly return the file.
                    $pipescriptOutput
                }


                # If the source generator returned an array
                elseif ($pipescriptOutput -is [Object[]]) {
                    # See if the array is only files.
                    $allFiles = @(foreach ($pso in $pipescriptOutput) {
                        if ($pso -isnot [IO.FileInfo]) { $false; break }
                        else { $true }
                    })

                    # If it was all files.
                    if (-not ($allFiles -ne $true)) {
                        $pipeScriptOutput # return them
                    } else {
                        # Otherwise, join the content by a space
                        $pipescriptOutput -join ' ' |
                            Set-Content -LiteralPath $outputPath # save it to the output path
                        Get-Item -LiteralPath $outputPath # and return the file.
                    }
                }

                # If the source generator returned any other type
                else {

                    $pipescriptOutput |
                        Set-Content -LiteralPath $outputPath # save it to the output path
                    Get-Item -LiteralPath $outputPath # and return the file.
                }
                return
            }
        }

        # If the -Command is an ```[Management.Automation.Language.AttributeAST]```
        elseif ($command -is [Management.Automation.Language.AttributeAST])
        {
            $AttributeSyntaxTree = $command

            # Check that the AttributeSyntaxTree is not a real type (return if it is)
            $attributeType = $AttributeSyntaxTree.TypeName.GetReflectionType()
            if ($attributeType) { return }

            # Check that the typename is not [Ordered] (return if it is).
            if ($AttributeSyntaxTree.TypeName.Name -eq 'ordered') { return }

            # Create a collection for positional arguments.
            $positionalArguments = @()

            # Get the name of the transpiler.
            $transpilerStepName  =
                if ($AttributeSyntaxTree.TypeName.IsGeneric) {
                    $AttributeSyntaxTree.TypeName.TypeName.Name
                } else {
                    $AttributeSyntaxTree.TypeName.Name
                }

            $foundTranspiler = :FoundCommand do {
                $foundIt = Get-Transpiler -TranspilerName "$transpilerStepName"
                if ($foundIt) {
                    $foundIt; break FindingTranspiler
                }
                foreach ($langName in 'PipeScript','PowerShell') {
                    if ($PSLanguage.$langName.Templates.$transpilerStepName) {
                        $PSLanguage.$langName.Templates.$transpilerStepName; break FoundCommand
                    }
                    if ($PSLanguage.$langName.Templates.("$langName.$transpilerStepName")) {
                        $PSLanguage.$langName.Templates.("$langName.$transpilerStepName"); break FoundCommand
                    }    
                }                
                $realCommandExists = $ExecutionContext.SessionState.InvokeCommand.GetCommand(($transpilerStepName -replace '_','-'), 'Function,Cmdlet,Alias')
                if ($realCommandExists) {
                    $realCommandExists; break FoundCommand
                }
            } while ($false)

            if ($InputObject) {
                if ($foundTranspiler -and -not $foundTranspiler.CouldPipe($InputObject)) {
                    $foundTranspiler = $null
                }
            }
                
            <## See if we could find a transpiler that fits.
            $foundTranspiler  =
                if ($InputObject) {
                    Get-Transpiler -TranspilerName "$transpilerStepName" -CouldPipe $InputObject |
                    Select-Object -ExpandProperty ExtensionCommand
                } else {
                    Get-Transpiler -TranspilerName "$transpilerStepName"
                }
            #>
            # Collect all of the arguments of the attribute, in the order they were specified.
            $argsInOrder = @(
                @($AttributeSyntaxTree.PositionalArguments) + @($AttributeSyntaxTree.NamedArguments) | Sort-Object { $_.Extent.StartOffset})


            # Now we need to map each of those arguments into either named or positional arguments.
            foreach ($attributeArg in $argsInOrder) {
                # Named arguments are fairly straightforward:
                if ($attributeArg -is [Management.Automation.Language.NamedAttributeArgumentAst]) {
                    $argName = $attributeArg.ArgumentName
                    $argAst  = $attributeArg.Argument
                    $parameter[$argName] =
                        if ($argName -eq $argAst) { # If the argument is the name,
                            $true # treat it as a [switch] parameter.
                        }
                        # If the argument value was an ScriptBlockExpression
                        elseif ($argAst -is [Management.Automation.Language.ScriptBlockExpressionAST]) {
                            # Turn it into a [ScriptBlock]
                            $argScriptBlock = [ScriptBlock]::Create($argAst.Extent.ToString() -replace '^\{' -replace '\}$')
                            # If the Transpiler had a parameter that took a [ScriptBlock] or [ScriptBlock[]]
                            if ($foundTranspiler.parameters.$argName.ParameterType -eq [ScriptBlock] -or
                                $foundTranspiler.parameters.$argName.ParameterType -eq [ScriptBlock[]]) {
                                $argScriptBlock # pass the [ScriptBlock] directly.
                            }
                            # Now here is where things get a bit more interesting:
                            # If the parameter type _was not_ a [ScriptBlock], we can evaluate the [ScriptBlock] to create a real value
                            # If we want to do this "safely", we can pass -SafeScriptBlockAttributeEvaluation
                            elseif ($SafeScriptBlockAttributeEvaluation) {
                                # Which will run the [ScriptBlock] inside of a data block, thus preventing it from running commands.
                                & ([ScriptBlock]::Create("data {$argScriptBlock}"))
                            } else {
                                # Otherwise, we want to run the [ScriptBlock] directly.
                                & ([ScriptBlock]::Create("$argScriptBlock"))
                            }
                        }
                        elseif ($argAst.Value) {
                            $argAst.Value.ToString()
                        }
                        else {
                            $argAst.Extent.ToString()
                        }
                } else {
                    $argValue = 
                        if ($attributeArg -is [Management.Automation.Language.ScriptBlockExpressionAST]) {
                            $argScriptBlock = [ScriptBlock]::Create($attributeArg.Extent.ToString() -replace '^\{' -replace '\}$')
                            if ($SafeScriptBlockAttributeEvaluation) {
                                # Which will run the [ScriptBlock] inside of a data block, thus preventing it from running commands.
                                & ([ScriptBlock]::Create("data {$argScriptBlock}"))
                            } else {
                                # Otherwise, we want to run the [ScriptBlock] directly.
                                & ([ScriptBlock]::Create("$argScriptBlock"))
                            }
                        } else {
                            $attributeArg.Value
                        }
                    # If we are a positional parameter, for the moment:
                    if ($parameter.Count) {
                        # add it to the last named parameter.
                        $parameter[@($parameter.Keys)[-1]] = @() + $parameter[@($parameter.Keys)[-1]] + $argValue
                    } else {
                        # Or add it to the list of string arguments.
                        $positionalArguments += $argValue
                    }                    
                }
            }

            # If we have found a transpiler, run it.
            if ($foundTranspiler) {
                $ArgumentList += $positionalArguments
                if ($InputObject) {
                    $inputObject |
                        & $foundTranspiler @ArgumentList @Parameter
                } else {
                    & $foundTranspiler @ArgumentList @Parameter
                }
            }            
            elseif ($script:TypeAcceleratorsList -notcontains $transpilerStepName -and $transpilerStepName -notin 'Ordered') {
                $psCmdlet.WriteError(
                    [Management.Automation.ErrorRecord]::new(
                        [exception]::new("Could not find a Transpiler or Type for [$TranspilerStepName]"),
                        'Transpiler.Not.Found',
                        'ParserError',
                        $command
                    )                    
                )

                return
            }

        }

        # If the -Command is an ```[Management.Automation.Language.TypeConstraintAST]```
        elseif ($command -is [Management.Automation.Language.TypeConstraintAst]) {
            $TypeConstraint = $command
            # Determine if the -Command is a real type.
            $realType = $Command.TypeName.GetReflectionType()
            if ($realType) {
                # If it is, return.
                return
            }
            # Next, make sure it's not ```[ordered]``` (return it if is)
            if ($command.TypeName.Name -eq 'ordered') { return}

            # Determine the name of the transpiler step.
            $transpilerStepName  =
                # If the typename is generic, the generic arguments will be treated as positional arguments
                if ($command.TypeName.IsGeneric) {
                    $command.TypeName.TypeName.Name # and the name will the root typename.
                } else {
                    $command.TypeName.Name  # Otherwise, the step will have no positional arguments, and it's name is the typename.
                }


            # Attempt to find the transpiler
            $foundTranspiler  =
                if ($InputObject) {
                    # If we had an -InputObject, be sure we can pipe it in.
                    foreach ($potentialTranspiler in Get-Transpiler -TranspilerName "$transpilerStepName") {
                        if ($potentialTranspiler.CouldPipe($inputObject)) {
                            $potentialTranspiler
                        }
                    }
                } else {
                    # Otherwise, just get the step by name.
                    Get-Transpiler -TranspilerName "$transpilerStepName"
                }

            # If the TypeName was generic, treat the generic parameters as arguments
            # ```[t[n,a]]``` would pass two positional parameters, n and a.
            # ```[t[a[b,c],d[e]]]``` would pass two named parameters @{a='b,'c';d='e'}
            if ($TypeConstraint.TypeName.IsGeneric) {
                $TypeConstraint.TypeName.GenericArguments |
                TypeConstraintToArguments |
                ForEach-Object {
                    if ($_.ArgumentList) {
                        $ArgumentList += $_.ArgumentList
                    }
                    if ($_.Parameter.Count) {
                        $parameter += $_.Parameter
                    }
                }
            }

            if ($foundTranspiler) {
                if ($InputObject) {
                    $inputObject | & $foundTranspiler @ArgumentList @Parameter
                } else {
                    & $foundTranspiler @ArgumentList @Parameter
                }
            } else {
                Write-Error "Could not find a Transpiler or Type for [$TranspilerStepName]" -Category ParserError -ErrorId 'Transpiler.Not.Found'
                return
            }
        }

        return
    }
}
