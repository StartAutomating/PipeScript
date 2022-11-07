<#
.Synopsis
    The Core PipeScript Transpiler
.Description
    The Core PipeScript Transpiler.

    This will convert various portions in the PowerShell Abstract Syntax Tree from their PipeScript syntax into regular PowerShell.
    
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
    # First off, we declare a few inner functions that we will use within only this script.
    $myCmd = $MyInvocation.MyCommand
}

process {
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
                            
                            $attrRealType = 
                                if ($attrAst.TypeName.GetReflectionType) {
                                    $attrAst.TypeName.GetReflectionType()
                                } elseif ($attrAst.TypeName.ToString) {
                                    $attrAst.TypeName.ToString() -as [type]
                                }
                                
                            if (-not $attrRealType) {
                                $attrAst
                            }
                        }
                    )
                
                $replacements = [Ordered]@{}
                $myOffset     = 0
                foreach ($moreTo in $moreToPreTranspile) {
                    $TranspilerAttributes += $moreTo.Extent.ToString()
                    $start = $scriptText.IndexOf($moreTo.extent.text, $myOffset)
                    $end   = $start + $moreTo.Extent.Text.Length
                    $replacements["$start,$end"] = ''
                }

                $UpdatedScript = Update-PipeScript -ScriptReplacement $replacements -ScriptBlock $ScriptBlock

                $scriptBlock = $UpdatedScript
            }

            $scriptText = "$scriptBlock"
            

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

            if (-not $ScriptBlock) { return }

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
            $astList = @($scriptBlock.Ast.FindAll({$true}, $false))
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
                # If skipUntil was set,
                if ($skipUntil) {
                    # find the space between now and the last known offset.
                    try {
                        $newOffset = $scriptText.IndexOf($item.Extent.Text, $myOffset)
                        if ($newOffset -eq -1) { continue }
                        $myOffset  = $newOffset
                    } catch {
                        $ex =$_
                        $null = $null
                    }
                    if ($myOffset -lt $skipUntil) { # If this is before our skipUntil point
                        continue # ignore this AST element.
                    }
                    $skipUntil = $null # If we have reached our skipUntil point, let's stop skipping.
                }
                # otherwise, find if any pipescripts match this AST

                # We can cache transpilers by type
                if (-not $script:TranspilerAstTypes) {
                    $script:TranspilerAstTypes = @{}
                }

                $itemTypeName = $item.GetType().Fullname
                if (-not $script:TranspilerAstTypes[$itemTypeName]) {
                    $script:TranspilerAstTypes[$itemTypeName] = Get-Transpiler -CouldPipe $item |
                        Where-Object { 
                            $_.ExtensionCommand.CouldRun(@{} + $_.ExtensionParameter)
                        }
                }

                # But we still need to determine if an extension is valid for a given type's context
                $pipescripts =  foreach ($potentialPipeScript in $script:TranspilerAstTypes[$itemTypeName]) {                    
                        if (
                        $potentialPipeScript.ExtensionCommand.CouldRun(@{} + $potentialPipeScript.ExtensionParameter) -and
                        $(
                            $eap = $ErrorActionPreference
                            $ErrorActionPreference = 'ignore'
                            $potentialPipeScript.ExtensionCommand.Validate($item, $true)
                            $ErrorActionPreference = $eap
                        )
                        ) {
                            $potentialPipeScript
                        }
                    }

                # If we found any matching pipescripts
                if ($pipescripts) {                    
                    :NextPipeScript 
                        foreach ($ps in $pipescripts) {
                            $pipeScriptOutput = Invoke-PipeScript -InputObject $item -CommandInfo $ps.ExtensionCommand
                            foreach ($pso in $pipeScriptOutput) {
                                if ($pso -is [Collections.IDictionary]) {
                                    $psoCopy = [Ordered]@{} + $pso                             
                                    foreach ($kv in @($psoCopy.GetEnumerator())) {
                                        if ($kv.Key -is [Management.Automation.Language.Ast]) {
                                            $astReplacements[$kv.Key] = $kv.Value
                                            $psoCopy.Remove($kv.Key)
                                        } elseif ($kv.Key -match '^\d,\d$') {
                                            $textReplacements["$($kv.Key)"] = $kv.Value
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
                                    # determine the end of this AST element
                                    $start = $scriptText.IndexOf($item.Extent.Text, $myOffset) 
                                    $end   = $start + $item.Extent.Text.Length
                                    $skipUntil = $end # set SkipUntil
                                    $AstReplacements[$item] = $pso # and store the replacement.                                    
                                }
                            }
                            # If the transpiler had output, do not process any more transpilers.
                            if ($pipeScriptOutput) { break }
                        }                
                } 
            }
            
            $newScript =
                if ($AstReplacements.Count) {            
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
            
            $transpiledScriptBlock
            # output the new script.
        }
        #endregion Transpile ScriptBlocks    
    }
}
