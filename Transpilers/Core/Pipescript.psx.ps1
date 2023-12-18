<#
.Synopsis
    The Core PipeScript Transpiler
.Description
    The Core PipeScript Transpiler.

    This can rewrite anything in the PowerShell Abstract Syntax Tree.

    The Core Transpiler visits each item in the Abstract Syntax Tree and sees if it can be converted.
    
    It will run other converters as directed by the source code.
.Link
    .>Pipescript.Function
.Link
    .>Pipescript.AttributedExpression
.EXAMPLE
    {
        function [explicit]ExplicitOutput {
            "whoops"
            return 1
        }
    } | .>PipeScript
.Example
    {        
        [minify]{
            # Requires PSMinifier (this comment will be minified away)
            "blah"
                "de"
                    "blah"
        }
    } | .>PipeScript
.Example
    .\PipeScript.psx.ps1 -ScriptBlock {
        [bash]{param([string]$Message) $message}
    }
.Example
    .\PipeScript.psx.ps1 -ScriptBlock {
        [explicit]{1;2;3;echo 4} 
    }
#>
<#
.EXAMPLE
    {
        function [ProxyCommand<'Get-Process'>]GetProcessProxy {}
    } | .>PipeScript
#>
param(
# A ScriptBlock that will be transpiled.
[Parameter(Mandatory,ParameterSetName='ScriptBlock',ValueFromPipeline,Position=0)]
[ScriptBlock]
$ScriptBlock,

# One or more transpilation expressions that apply to the script block.
[Parameter(ParameterSetName='ScriptBlock')]
[string[]]
$Transpiler
)

begin {
    $myCmd = $MyInvocation.MyCommand

    # Set up a global variable for all commands.
    # This will actually return an enumerable, which we can re-enumerate any number of times we want.
    $global:AllCommands = $ExecutionContext.SessionState.InvokeCommand.GetCommands('*', 'Alias,Function,Cmdlet',$true)    

    function RefreshTranspilers([switch]$Force) {
        $PotentialTranspilers = @(
            $PSLanguage.PipeScript.Templates.All 
            $PSLanguage.PowerShell.Templates.All
            Get-Transpiler -Force:$Force            
        ) | 
            Sort-Object Order, Name

        $TranspilersByType = [Ordered]@{}
        foreach ($PotentialTranspiler in $PotentialTranspilers) {

            <#foreach ($stronglyPipedType in @($PotentialTranspiler.StrongPipeType)) {
                if (-not $stronglyPipedType) { continue }
                if (-not $TranspilersByType[$stronglyPipedType]) {
                    $TranspilersByType[$stronglyPipedType] = [Collections.Generic.List[PSObject]]::new()
                }
                $TranspilersByType[$stronglyPipedType].Add($PotentialTranspiler)
            }#>
            
            $potentialTranspilerCommandMetadata = $PotentialTranspiler -as [Management.Automation.CommandMetadata]    
            :nextParameter foreach ($parameterMetaData in $potentialTranspilerCommandMetadata.Parameters.Values) {
                foreach ($paramSet in $parameterMetaData.ParameterSets.Values) {
                    if ($paramSet.ValueFromPipeline) {
                        if (-not $TranspilersByType[$parameterMetaData.ParameterType]) {
                            $TranspilersByType[$parameterMetaData.ParameterType] = [Collections.Generic.List[PSObject]]::new()
                        }
                        $TranspilersByType[$parameterMetaData.ParameterType].Add($PotentialTranspiler)
                        continue nextParameter
                    }                    
                }
            }
        }

        $TranspilersCachedAt = [datetime]::Now
    }    

    . RefreshTranspilers
    
    $TranspilationCallstack = Get-PSCallStack
    $IsNested = foreach ($callstackEntry in $TranspilationCallstack) {
        if ($callstackEntry.InvocationInfo.MyCommand.Name -eq $myCmd.Name) {
            if ($callstackEntry.InvocationInfo -ne $MyInvocation) {
                $true; break
            }
        }
    }
    $pipeScriptCommands = @()
    $preCommands  = @()
    $postCommands = @()
    if (-not $IsNested) {
        $pipeScriptCommands = $ExecutionContext.SessionState.InvokeCommand.GetCommands('PipeScript*', 'Function,Alias', $true)
        foreach ($pipeScriptCommand in $pipeScriptCommands) {
            if ($pipeScriptCommand.Name -match '^PipeScript.(?>Pre|Analyze)' -and 
                $pipeScriptCommand.CouldPipeType([scriptblock])) {
                $preCommands += $pipeScriptCommand
            }
            if ($pipeScriptCommand.Name -match '^PipeScript.(?>Post|Optimize)' -and
                $pipeScriptCommand.CouldPipeType([scriptblock])                
            ) {
                $postCommands += $pipeScriptCommand
            }
        }
        $preCommands = $preCommands | Sort-Object Rank, Name
        $postCommands = $postCommands | Sort-Object Rank, Name
    }
}

process {
    if (-not $IsNested -and $preCommands) {
        foreach ($pre in $preCommands) {
            $preOut = $ScriptBlock | & $pre
            if ($preOut -and $preOut -is [scriptblock]) {
                $ScriptBlock = $preOut
            }
        }
    }
    # First, make a copy of our input parameters.
    $invocationParams = [Ordered]@{} + $PSBoundParameters

    # Then, check on which parameter set is being used
    switch ($PSCmdlet.ParameterSetName) {
        #region Transpile ScriptBlocks
        ScriptBlock {
            # Walk thru any provided transpilers
            $TranspilerAttributes = @()
            $RemainingTranspilers = @()
            $scriptText = "$scriptBlock"
            foreach ($transpilerExpression in $invocationParams['transpiler']) {
                # If the transpiled expression doesn't use variables (except for true or false),
                if ($transpiledExpression -notmatch '(?>\@|\$(?!(?>true|false)))') {
                    # we will make the expression into a psuedo-attribute.
                    $TranspilerAttributes += $transpilerExpression -replace 
                        '\<', '(' -replace '\>', ')' -replace # To do this, replace <> with ()
                        '^([^\[])', '[$1' -replace '([^\]])$', '$1]' -replace # then ensure the attribute begins and ends with brackets
                        '(?<=[^\)])\]$', '()]' # and then ensure that it has a set of empty parenthesis at the end.
                } else {
                    $RemainingTranspilers += $transpilerExpression # Keep track of any other transpilers (for future use).
                }
            }
            
            # If the ScriptBlock had attributes, we'll add them to a special list of things that will be transpiled first.
            if ($ScriptBlock.Ast.ParamBlock.Attributes) {
                # To determine what we transpile first,
                $moreToPreTranspile =
                    @(
                        # check each ScriptBlock attribute
                        foreach ($attrAst in $ScriptBlock.Ast.ParamBlock.Attributes) {
                            # and see if it is a real type.
                            $attrRealType = 
                                if ($attrAst.TypeName.GetReflectionType) {
                                    $attrAst.TypeName.GetReflectionType()
                                } elseif ($attrAst.TypeName.ToString) {
                                    $attrAst.TypeName.ToString() -as [type]
                                }
                            
                            # If it is not a real type, 
                            if (-not $attrRealType) {
                                $attrAst # we will transpile it with the whole script block as input.
                            }
                        }
                    )
                
                # Now, we strip away any Attribute Based Composition.
                $replacements = [Ordered]@{}
                $myOffset     = 0
                # To do this effeciently, we collect all of the attributes left to pretranspile
                foreach ($moreTo in $moreToPreTranspile) {                                        
                    $TranspilerAttributes += $moreTo.Extent.ToString()
                    $start = $scriptText.IndexOf($moreTo.extent.text, $myOffset)
                    $end   = $start + $moreTo.Extent.Text.Length
                    $replacements["$start,$end"] = '' # and replace each of them with a blank.
                }

                # get the updated script,
                $UpdatedScript = Update-PipeScript -ScriptReplacement $replacements -ScriptBlock $ScriptBlock
                $scriptBlock = $UpdatedScript # and replace $ScriptBlock.
            }


            # Now we set the to the contents of the scriptblock.
            $scriptText = "$scriptBlock"

            # If there was no ScriptBlock, return
            if (-not $ScriptBlock) { return }            

            $PreTranspile =
                if ($transpilerAttributes) {
                    [ScriptBlock]::Create(
                        ($TranspilerAttributes -join [Environment]::NewLine) + $(
                            if (-not $ScriptBlock.Ast.ParamBlock) {
                                "param()" + [Environment]::NewLine
                            }
                        ) + $ScriptBlock
                    )
                }

            # If there were any attributes that can be pre-transpiled, convert them.
            if ($PreTranspile.Ast.ParamBlock.Attributes) {
                # Get the list of transpilation attributes
                $attrList = @($PreTranspile.Ast.ParamBlock.Attributes)
                $currentInput = $ScriptBlock  # and set the current input to this script block.
                # Then walk backwards thru the attribute list
                for ($attrIndex = $attrList.Length - 1; $attrIndex -ge 0; $attrIndex--) {
                    # and invoke the transpiler by name
                    $currentOutput = $currentInput | Invoke-PipeScript -AttributeSyntaxTree $attrList[$attrIndex]
                    if ($currentOutput -and $currentOutput -ne $attrList[$attrIndex]) {
                        $currentInput  = $currentOutput
                    }                    
                }

                
                # If the current output is a [ScriptBlock]
                if ($currentOutput -is [scriptblock]) {
                    # reset the script block.
                    $ScriptBlock = $currentOutput
                } elseif ( # Otherwise, if we can convert the string to a ScriptBlock without error
                    $currentOutput -is [string] -and $(
                    $CurrentOutputAsScriptBlock = try { [scriptblock]::Create($currentOutput)} catch { $null }
                    $CurrentOutputAsScriptBlock
                )) {
                    # reset the script block.
                    $ScriptBlock = $CurrentOutputAsScriptBlock
                }
            }
            
            # Find all AST elements within the script block.
            $astList = @($scriptBlock.Ast.FindAll({$true}, $true))
            # Prepare to replace code by stringifying the -ScriptBlcok, 
            $scriptText = "$scriptBlock"
            # creating an ordered dictionary of replacements, 
            $replacements = [Ordered]@{}
            $AstReplacements = [Ordered]@{}
            # and a list of Update-PipeScript splats
            $updateSplats = @()
            
            # At various points within transpilation, we will be skipping processing until a known end pointer.  For now, set this to null.
            $skipUntil  = 0
            # Keep track of the offset from a starting position as well, for the same reason.
            $myOffset   = 0
        
            # Walk over each item in the abstract syntax tree.
            :NextAstItem foreach ($item in $astList) {                
                $astForeach = $foreach
                # If skipUntil was set,
                if ($skipUntil) {
                    # find the space between now and the last known offset.
                    $myOffset = $item.Extent.StartOffset
                    if ($myOffset -lt $skipUntil) { # If this is before our skipUntil point
                        continue # ignore this AST element.
                    }
                    $skipUntil = $null # If we have reached our skipUntil point, let's stop skipping.
                }
                # otherwise, find if any pipescripts match this AST                

                # We've cached transpilers by type, but subclassing is a thing.
                # so we need to get all of the potential types
                $transpilerTypes = @($TranspilersByType.Keys) -as [type[]]
                # and then return a range of items
                $PotentialTranspilersForItem = @(foreach ($transpilerCommand in 
                    $TranspilersByType[@(foreach ($transpilerType in $transpilerTypes) {
                        if ($item -as $transpilerType) { # (where we could cast the input to the desired type).
                            $transpilerType
                        }
                    })]) {
                    $transpilerCommand
                })
                $itemTypeName = $item.GetType().Fullname
                                
                # Of course we still need to determine if an extension is valid for a given type's context
                $pipescripts =  foreach ($potentialPipeScript in $PotentialTranspilersForItem) {                    
                    $couldPipe   = $potentialPipeScript.CouldPipe($item)
                    if (-not $couldPipe -or 
                        $couldPipe -isnot [Collections.IDictionary]) { continue }
                    if ($potentialPipeScript.CouldRun(@{} + $couldPipe) -and
                        $(
                            $eap = $ErrorActionPreference
                            $ErrorActionPreference = 'ignore'
                            $potentialPipeScript.Validate($item, $true)
                            $ErrorActionPreference = $eap
                        )
                        ) {
                            $potentialPipeScript
                        }
                    }

                # If we found any matching pipescripts
                if ($pipescripts) {
                    # try to run each one.
                    :NextPipeScript foreach ($ps in $pipescripts) {
                        # If it had output
                        $pipeScriptOutput = Invoke-PipeScript -InputObject $item -CommandInfo $ps
                        # Walk over each potential output
                        foreach ($pso in $pipeScriptOutput) {
                            # If the output was a dictionary, treat it as a series of replacements.
                            if ($pso -is [Collections.IDictionary]) {                                
                                $psoCopy = [Ordered]@{} + $pso
                                foreach ($kv in @($psoCopy.GetEnumerator())) {
                                    # If the key was an AST element
                                    if ($kv.Key -is [Management.Automation.Language.Ast]) {
                                        # replace the element with it's value
                                        $astReplacements[$kv.Key] = $kv.Value
                                        $psoCopy.Remove($kv.Key)
                                    } elseif ($kv.Key -match '^\d+,\d+$') {
                                        # otherwise, it the key was a pair of digits, replace that span.
                                        $Replacements["$($kv.Key)"] = $kv.Value
                                        $psoCopy.Remove($kv.Key)
                                    }
                                }
                                if ($psoCopy.Count) {
                                    $updateSplats += $psoCopy
                                }                            
                            }
                            # If we have ouput from any of the scripts (and we have not yet replaced anything)
                            elseif ($pso -and -not $AstReplacements[$item]) 
                            {                                                                 
                                $skipUntil = $item.Extent.EndOffset # set SkipUntil
                                $AstReplacements[$item] = $pso # and store the replacement.
                            }

                            $LastFunctionDefinedAt =
                                try {
                                    @(Get-Event -SourceIdentifier PipeScript.Function.Transpiled -ErrorAction Ignore)[-1].TimeGenerated
                                } catch {
                                    $TranspilersCachedAt
                                }

                            #region Special Properties

                            # Because PowerShell can attach properties to any object,
                            # we can use the presence of attached properties to change context around the replacement.
                            # This happens regardless of if there is already a replacement for the current item.

                            # .SkipUntil or .IgnoreUntil can specify a new index or AST end point
                            foreach ($toSkipAlias in 'SkipUntil', 'IgnoreUntil') {                                    
                                foreach ($toSkipUntil in $pso.$toSkipAlias) {
                                    if ($toSkipUntil -is [int] -and $toSkipUntil -gt $end) {
                                        $skipUntil = $toSkipUntil
                                    } elseif ($toSkipUntil -is [Management.Automation.Language.Ast]) {
                                        $newSkipStart = $scriptText.IndexOf($toSkipUntil.Extent.Text, $myOffset)
                                        if ($newSkipStart -ne -1) {
                                            $end   = $toSkipUntil.Extent.EndOffset
                                            if ($end -gt $skipUntil) {
                                                $skipUntil = $end
                                            }
                                            if ($toSkipUntil -ne $item) {
                                                $AstReplacements[$toSkipUntil] = ''
                                            }
                                        }
                                    }
                                }
                            }                            

                            #.ToRemove,.RemoveAST, or .RemoveElement will remove AST elements or ranges
                            foreach ($toRemoveAlias in 'ToRemove','RemoveAST','RemoveElement') {
                                foreach ($toRemove in $pso.$toRemoveAlias) {
                                    if ($toRemove -is [Management.Automation.Language.Ast]) {
                                        $AstReplacements[$toRemove] = ''
                                    } elseif ($toRemove -match '^\d+,\d+$') {
                                        $Replacements[$toRemove] = ''
                                    }
                                }
                            }

                            #.ToReplace,.ReplaceAST or .ReplaceElement will replace elements or ranges.
                            foreach ($toReplaceAlias in 'ToReplace','ReplaceAST','ReplaceElement') {
                                foreach ($toReplace in $pso.$toReplaceAlias) {
                                    if ($toReplace -isnot [Collections.IDictionary]) {
                                        continue
                                    }
                                    foreach ($tr in $toReplace.GetEnumerator()) {
                                        if ($tr.Key -is [Management.Automaton.Language.Ast]) {
                                            $AstReplacements[$tr.Key] = $tr.Value
                                        } elseif ($tr.Key -match '^\d+,\d+$') {
                                            $textReplacements["$($tr.Key)"] = $tr.Value
                                        }
                                    }
                                }
                            }
                            #endregion Special Properties

                            if ($TranspilersCachedAt -le $LastFunctionDefinedAt) {
                                . RefreshTranspilers -Force
                                $astForeach.Reset()
                                continue NextAstItem
                            }
                        }
                        # If the transpiler had output, do not process any more transpilers.
                        if ($pipeScriptOutput) { break }
                    }                
                } 
            }
            
            $newScript =            
                if ($AstReplacements.Count) { 
                    # If there were replacements, we may need to compile them
                    foreach ($astReplacement in @($AstReplacements.GetEnumerator())) {
                        if ($astReplacement.Value -is [scriptblock] -and $astReplacement.Value.Transpilers) { # If the output was a [ScriptBlock]
                            # call ourself with the replacement, and update the replacement (if there was nothing to replace, this part of the if will be avoided)
                            $astReplacements[$astReplacement.Key] = & $MyInvocation.MyCommand.ScriptBlock -ScriptBlock $astReplacement.Value
                        }
                    }
                    # Call Update-PipeScript once with all of the changes.
                    Update-PipeScript -ScriptBlock $ScriptBlock -ScriptReplacement $replacements -AstReplacement $AstReplacements
                } elseif ($updateSplats) {
                    foreach ($upSplat in $updateSplats) {
                        $newScript = Update-PipeScript -ScriptBlock $ScriptBlock @upSplat
                        if ($newScript -is [ScriptBlock]) {
                            $scriptBlock = $newScript
                        }
                    }
                    $scriptBlock
                } else {
                    $scriptBlock
                }
            
            $transpiledScriptBlock =
                [ScriptBlock]::Create($newScript)

            if (-not $IsNested -and $postCommands) {                
                foreach ($post in $postCommands) {
                    $postProcessStart = [DateTime]::now
                    $postOut = $transpiledScriptBlock | & $post 
                    $postProcessEnd = [DateTime]::now
                    $null = New-Event -SourceIdentifier "PipeScript.PostProcess.Complete" -Sender $ScriptBlock -EventArguments $post -MessageData ([PSCustomObject][Ordered]@{
                        Command = $post
                        InputObject = $transpiledScriptBlock
                        Duration = ($postProcessEnd - $postProcessStart)
                    })
                    if ($postOut -and $postOut -is [scriptblock]) {
                        $transpiledScriptBlock = $postOut
                    }
                }                                
            }
            
            $transpiledScriptBlock
            # output the new script.
        }
        #endregion Transpile ScriptBlocks    
    }
}
