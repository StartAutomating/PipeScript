function Join-PipeScript
{
    <#
    .SYNOPSIS
        Joins PowerShell and PipeScript ScriptBlocks
    .DESCRIPTION
        Joins ScriptBlocks written in PowerShell or PipeScript.
    .EXAMPLE
        Get-Command Join-PipeScript | Join-PipeScript
    .EXAMPLE
        {param([string]$x)},
        {param([string]$y)} | 
            Join-PipeScript # Should -BeLike '*param(*$x,*$y*)*'
    .EXAMPLE
        {
            begin {
                $factor = 2
            }
        }, {
            process {
                $_ * $factor
            }
        } | Join-PipeScript
    .EXAMPLE
        {
            param($x = 1)
        } | Join-PipeScript -ExcludeParameter x
    .LINK
        Update-PipeScript    
    #>
    [Alias('Join-ScriptBlock', 'jps')]
    param(
    # A ScriptBlock written in PowerShell or PipeScript.
    [Parameter(Mandatory,ParameterSetName='ScriptBlock',ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [Alias('Definition')]
    [ScriptBlock[]]
    $ScriptBlock,

    # A list of block types to be excluded during a merge of script blocks.
    # By default, no blocks will be excluded.
    [ValidateSet('using', 'requires', 'help','header','param','dynamicParam','begin','process','end')]
    [Alias('SkipBlockType','SkipBlockTypes','ExcludeBlockTypes')]
    [string[]]
    $ExcludeBlockType,

    # A list of block types to include during a merge of script blocks.
    [ValidateSet('using', 'requires', 'help','header','param','dynamicParam','begin','process','end')]
    [Alias('BlockType','BlockTypes','IncludeBlockTypes')]
    [string[]]
    $IncludeBlockType = @('using', 'requires', 'help','header','param','dynamicParam','begin','process','end'),

    # If set, will transpile the joined ScriptBlock.    
    [switch]
    $Transpile,

    # A list of parameters to include.  Can contain wildcards.
    # If -IncludeParameter is provided without -ExcludeParameter, all other parameters will be excluded.
    [string[]]
    $IncludeParameter,

    # A list of parameters to exclude.  Can contain wildcards.
    # Excluded parameters with default values will declare the default value at the beginnning of the command.
    [string[]]
    $ExcludeParameter,

    # The amount of indentation to use for parameters and named blocks.  By default, four spaces.
    [ValidateRange(0,12)]
    [Alias('Indentation')]
    [int]
    $Indent = 4
    )

    begin {
        # Join-PipeScript is going to join a bunch of script blocks.
        $AllScriptBlocks = @()

        # To do this 'right', we will need some little functions and filters
        
        # We'll need to indent the start of a script by a given level.
        filter IndentAst {
            $ast = $_            
            (' ' * ($ast | MeasureIndent)) + "$($ast.Extent)"    # combine the statements a newline.            
        }

        # To do that right, we'll need to Measure Indentation (based off of the least indented line)
        filter MeasureIndent {
            $ast = $_
            $parentExtent = $ast.Parent.Extent
            if (-not $parentExtent) { 
                return 0
            }
            $untilLineStart = [Regex]::new('(?<=[\r\n])[\s-[\r\n]]{0,}', 'RightToLeft,Singleline')
            $distanceFromParent   = $ast.Extent.StartOffset - $parentExtent.StartOffset
            return $untilLineStart.Match($parentExtent.ToString(), $distanceFromParent).Length
        }
    }

    process {
        # Our process block is fairly simple, we just collect the [ScriptBlock]s as they come in
        if ($ScriptBlock) {
            $AllScriptBlocks += $ScriptBlock
        }
    }

    end {
        # Before we go too far, we want both -BlockType and -ExcludeBlockType to work.
        # and they are both lists with the same finite set of values,
        # we can simply filter out any -BlockType that are in -ExcludeBlockType.
        if ($ExcludeBlockType) {
            foreach ($skipBlock in $ExcludeBlockType) {
                if ($IncludeBlockType -contains $skipBlock) {
                    $IncludeBlockType = $IncludeBlockType -ne $skipBlock
                }
            }
        }

        # Now we collect all of the script blocks to merge
        $AllScriptBlocks  = @(            
        foreach ($toMerge in $AllScriptBlocks) {
            if ($toMerge -match '^\s{0,}$') { continue }
            # If the script block had a body (aka a function definition), join the body.
            if ($toMerge.Ast.body) {
                [ScriptBlock]::Create($toMerge.Ast.Body.Extent.ToString() -replace '^\{' -replace '\}$')
            } else {
                $toMerge
            }
        })

        $NamedBlocks = @()

        # If we have any other named blocks than end, we need to close the end block.
        # So set up a boolean to track this.
        [bool]$closeEndBlock = $false
        
        # If we're including headers or help
        if ($IncludeBlockType -contains 'Header' -or $IncludeBlockType -contains 'Help') {            
            $allHeaderBlocks = @(
                # walk over each parameter block
                foreach ($combined in $AllScriptBlocks.Ast.ParamBlock) {
                    if (-not $combined.Parent.Extent) { continue }
                    # and extract the difference between the parent and the start of the block
                    $offsetDifference = $combined.Extent.StartOffset - $combined.Parent.Extent.StartOffset
                    # (this is where the header and help reside)
                    # try to strip off leading braces and whitespace
                    $headerblock = $combined.Parent.Extent.ToString().Substring(0, $offsetDifference) -replace '^[\r\n\s]{0,}\{'
                    # and remove blank lines
                    $headerblock = $headerblock -split '(?>\r\n|\n)' -notmatch '^\s{0,}$' -join [Environment]::NewLine
                    $headerblock
                }                        
            )

            # If we had any header blocks
            if ($allHeaderBlocks) {
                # We need to sort the header and the help.

                # To do this, we can use this regex to find block comments.
                $helpRegex = [Regex]::New('
                \<\# # The opening tag
                (?<Block> 
                    (?:.|\s)+?(?=\z|\#>) # anything until the closing tag
                )
                \#\> # the closing tag
                ', 'IgnoreCase,IgnorePatternWhitespace','00:00:05')

                # Now keep track of the rest of the headers and the combined help.
                $restOfHeaders = @()
                $combinedHelp  = @() # Walk over each header block
                foreach ($headerblock in $allHeaderBlocks) {
                    # If the block had help
                    if ($headerblock -match $helpRegex) { 
                        $combinedHelp  += $matches.Block # add it to combined help
                        # and remove it to get the rest of the headers.
                        $restOfHeaders += $headerblock -replace $helpRegex
                    } else {
                        # otherwise, just add the block to the headers.
                        $restOfHeaders += $headerblock
                    }                                        
                }
                
                # Now, collect all of the header blocks
                $allHeaderBlocks = @(
                    # If we're including -Help and we have $combinedHelp
                    if ($IncludeBlockType -contains 'Help' -and $combinedHelp) {                    
                        (' ' * $Indent) + "<#"  # create a comment block               
                        $combinedHelp -split '(?>\r\n|\n)' -join (' ' * $Indent) + [Environment]::NewLine # and join the content.
                        (' ' * $Indent) + '#>'
                    }
                ) + @(
                    # If we're including headers, add the rest of the headers.
                    if ($IncludeBlockType -contains 'Header') {
                        (' ' * $Indent) + (
                            $restOfHeaders -split '(?>\r\n|\n)' -join (' ' * $Indent) + [Environment]::NewLine
                        )
                    }
                )

                # Now that the header is sorted, we're ready to join the script.
            }
        }        
        
        

        #region Joining the Scripts

        # To join the scripts, we want to go thru block type by block type.
        $joinScriptLines = @(
            # First _have_ to be using statements.
            $allUsingLines = @(
                if ($IncludeBlockType -contains 'using') {
                    foreach ($usingStatement in $AllScriptBlocks.Ast.UsingStatements) {
                        # They are easy:  just .ToString() their extent.
                        $usingStatement.Extent.ToString()
                    }                
                }
            )

            $allUsingLines

            $allRequireStatements = @(
                # Next we have requirements
                if ($IncludeBlockType -contains 'requires') {
                    # unfortunately, these do not have an easy .ToString()
                    # (this is why the type has been extended to have a .Script property (#234))
                    foreach ($requirement in $AllScriptBlocks.Ast.ScriptRequirements) {
                        if (-not $requirement) { continue }
                        $requirement.Script.ToString()
                    }
                }
            )

            $allRequireStatements


            # If we're including header or help, we'll want to include whatever blocks we have.
            # (if you recall, we've already filtered this list).
            if ($IncludeBlockType -contains 'header' -or $IncludeBlockType -contains 'help') {                
                $allHeaderBlocks
            }
            
            # param is probably the trickiest section, but since we're building this script from top to bottom
            # it's next on the list.

            # We _might_ need to add some statements to the script (because of -Include/ExcludeParameter)
            $StatementsToAdd = @()

            if ($IncludeBlockType -contains 'param') {
                # To start off with, this is the first block we need to name and indent
                # (at least, if we have any parameter blocks)
                $allParamBlocks = @(
                if (@($AllScriptBlocks.Ast.ParamBlock) -ne $null) {
                    # if we do, use the first non-null parameter block to determine the indentation level.
                    ' ' * (@(@($AllScriptBlocks.Ast.ParamBlock) -ne $null)[0] | MeasureIndent) + "param("
                }

                # Ok, next we go thru each script block and combine the parameters.
                # Because a parameter may appear more than once, we need to keep track of which ones we have alreadyIncluded.
                $alreadyIncludedParameter = [Ordered]@{}

                
                # Now we walk over each param block, and collect output into $paramOut as we go.
                $paramOut = @(foreach ($paramBlock in $AllScriptBlocks.Ast.ParamBlock) {
                    # The parameter index for each set of parameters is important, because it dictates where we look for help.
                    $parameterIndex  = 0
                    # Now we walk over the parameters from a given paramblock
                    foreach ($parameter in $paramBlock.parameters) {
                        # and we determine the name of each parameter.
                        $variableName = $parameter.Name.VariablePath.ToString()
                        
                        # With the name in hand, we can check -IncludeParameter and -ExcludeParameter 
                        if ($IncludeParameter -or $ExcludeParameter) {                            
                            $shouldIncludeParameter = # If -IncludeParameter was not specified
                                if (-not $IncludeParameter) { $true } # we should include it
                                else {
                                    # otherwise we only include it if any of the wildcards match.
                                    foreach ($inc in $IncludeParameter) { 
                                        if ($variableName -like $inc) {
                                            $true;break
                                        }
                                    }
                                }
                            
                            # We should only -Exclude if any of the wildcards match.
                            $shouldExcludeParameter = 
                                foreach ($exc in $ExcludeParameter) {
                                    if ($variableName -like $exc) { $true; break }                                    
                                }

                            # If we shouldn't include or should exclude any given parameter
                            if (-not $shouldIncludeParameter -or $shouldExcludeParameter) {
                                # check for a default value
                                if ($parameter.DefaultValue) {
                                    # and add it to the statements to add.
                                    $statementsToAdd += "`$$($variableName) = $($parameter.DefaultValue)"
                                }

                                $parameterIndex++
                                continue
                            }
                        }
                        
                        # If we had not already included the parameter
                        if (-not $alreadyIncludedParameter[$variableName]) {                            
                            # Get the parameter's inline help.
                            $inlineParameterHelp = # For the first parameter, this is 
                                if ($parameterIndex -eq 0) { # For the first parameter
                                    $parentExtent = $parameter.Parent.Extent.ToString()
                                    # This starts after the first parenthesis. 
                                    $afterFirstParens = $parentExtent.IndexOf('(') + 1
                                    # and goes until the start of the parameter.
                                    $parentExtent.Substring($afterFirstParens, 
                                        $parameter.Extent.StartOffset - 
                                            $parameter.Parent.Extent.StartOffset - 
                                                $afterFirstParens) -replace '^[\s\r\n]+'
                                    # (don't forget to trim leading whitespace)
                                } else {
                                    # for every other parameter it is the content between parameters.
                                    $lastParameter   = $parameter.Parent.Parameters[$parameterIndex - 1]
                                    $relativeOffset  = $lastParameter.Extent.EndOffset + 1 - $parameter.Parent.Extent.StartOffset
                                    $distance        = $parameter.Extent.StartOffset - $lastParameter.Extent.EndOffset - 1
                                    # (don't forget to trim leading whitespace and commas)
                                    $parameter.Parent.Extent.ToString().Substring($relativeOffset,$distance) -replace '^[\,\s\r\n]+'
                                }
                            
                            $inlineParameterHelp = $inlineParameterHelp -split '(?>\r\n|\n)' -join (
                                (' ' * $indent) + [Environment]::NewLine
                            )

                            # Then output the included parameter.
                            $alreadyIncludedParameter[$variableName]  = $inlineParameterHelp + $parameter.Extent.ToString()
                            $alreadyIncludedParameter[$variableName]
                        } else {                            
                            $oldParam = "param (" + [Environment]::NewLine + 
                                $($alreadyIncludedParameter[$variableName]) + 
                                [Environment]::NewLine + 
                                ")"                                
                            $oldParamScriptBlock = [ScriptBlock]::Create($oldParam)
                            $oldParameter = $oldParamScriptBlock.Ast.ParamBlock.Parameters[0]                                
                                                        
                            # For the moment, parameters are not merged.  This could be improved upon.
                        }
                        
                        $parameterIndex++
                    }                                        
                }) 
                
                # Join all parameters by a comma, two newlines, and four indented spaces.
                (' ' * $Indent) + (
                    $paramOut -notmatch '^[\s\r\n]$' -join (',' + ([Environment]::NewLine * 2) + (' ' * $Indent))
                )
                
                # and close out the parameter block.
                if (@($AllScriptBlocks.Ast.ParamBlock) -ne $null) {
                    ' ' * (@(@($AllScriptBlocks.Ast.ParamBlock) -ne $null)[0] | MeasureIndent) + ")"
                }

                )

                $allParamBlocks

                $NamedBlocks += 'param'
            }
            elseif ($IncludeBlockType -contains 'Header' -or $IncludeBlockType -contains 'Help') {
                'param()'
            }


            # We can do the next three blocks the same way:
            foreach ($BlockName in 'dynamicParam','begin','process') {
                # We need to walk thru each named block of a given ScriptBlock
                # (unless they're not in the list)
                if ($IncludeBlockType -notcontains $BlockName) { continue }
                $blocks = @($AllScriptBlocks.Ast."${BlockName}Block")
                if ($blocks -ne $null) {                    
                    # If any of these block names exist, we will need to close the end block (if it exists).
                    $NamedBlocks += $BlockName
                    $closeEndBlock = $true                    
                    $blockOpen = $false
                    foreach ($block in $blocks) {
                        if (-not $block) { continue } # (skipping ones that are empty)
                        if (-not $blockOpen) {  # If the block hasn't been opened yet
                            $blockOpen = $true # open it
                            if ($StatementsToAdd) {
                                $StatementsToAdd -join [Environment]::NewLine
                                (' ' * $indent) + (
                                    $block.Extent.ToString() -replace "^$blockName\s{0,}\{" -replace '\}$'
                                )
                                $StatementsToAdd = $null
                            } else {
                                (' ' * $indent) + (
                                    ($block | IndentAst) -replace '\}$' # and remove trailing curly braces.
                                )
                            }                       
                            
                        } else {
                            # Otherwise, get the block content, removing the opening and closing braces.
                            $block.Extent.ToString() -replace "^$blockName\s{0,}\{" -replace '\}$'
                        }
                    }
                    ' ' * ([Math]::Max($indent,($block | MeasureIndent))) + '}'
                }
            }

            if ($IncludeBlockType -contains 'end') {
                # If there were end blocks declared
                $blocks = @($AllScriptBlocks.Ast.EndBlock)
                if ($blocks -ne $null) {                    
                    $unnamedBlocks = @($blocks.Unnamed)
                    $emptyBlockCount = 0
                    foreach ($block in $blocks) {
                        if (-not $block) { $emptyBlockCount++;continue }
                        # Empty(ish) scripts may have an end bock that is an empty param block
                        if ($block -match '^\s{0,}param\(\s{0,}\)\s{0,}$') { $emptyBlockCount++; continue } # (skip those).
                        if (-not $blockOpen -and -not $block.Unnamed) {
                            # If the end block was named, it will need to be closed.
                            if ($StatementsToAdd) {
                                $StatementsToAdd -join [Environment]::NewLine
                                $block.Extent.ToString() -replace '^end\s{0,}\{' -replace '\}$' -replace '^param\(\)[\s\r\n]{0,}'
                                $StatementsToAdd = $null
                            } else {
                                ($block | IndentAst) -replace '\}$' # and remove trailing curly braces.
                            }                            
                            $closeEndBlock = $true
                            $blockOpen = $true
                        } elseif ($block.Statements.Count) {
                            # where as if it is a series of statements, it doesn't necessarily need to be.
                            # Unless it's the first block and it's unnamed, and other blocks are named.
                            if ($block.Unnamed -and -not $blockOpen -and 
                                $unnamedBlocks.Length -ne $blocks.Length) {
                                ' ' * ($block | MeasureIndent) + 'end {'
                                $blockOpen = $true
                                $closeEndBlock = $false
                            } elseif ($blockOpen) {
                                # If there was already a block open, we need to name the end block
                                ' ' * ($block | MeasureIndent) + 'end {'
                                $closeEndBlock = $true
                            }
                            if ($StatementsToAdd) {
                                $StatementsToAdd -join [Environment]::NewLine
                                $StatementsToAdd = $null
                            }                            
                            
                            # If the block was unnamed
                            if ($block.Unnamed) {
                                # check to see if there were any paramters declared
                                if ($block.Parent.ParamBlock.Parameters) {
                                    # because for some silly reason, the AST _loves_ to include that in the end block as well                                    
                                    $block.Extent.ToString().Substring($block.Parent.ParamBlock.Extent.ToString().Length) -replace 
                                        '[\s\r\n]{0,}$' # (don't forget to trim trailing whitespace).
                                } else {
                                    # If no parameters were declared, remove the empty param() block.
                                    $block.Extent.ToString() -replace '^param\(\)[\s\r\n]{0,}'
                                }                                    
                            } else {
                                # If the block was named
                                $block.Extent.ToString() -replace # Strip the 'end' and braces
                                    '^end\s{0,}\{' -replace '\}$' -replace 
                                    '^param\(\)[\s\r\n]{0,}' # and any empty param blocks.
                            }                            
                        } elseif (-not $block.Statements.Count) {
                            $emptyBlockCount++                            
                        }
                    }

                    if ($StatementsToAdd) {
                        if ($closeEndBlock -and -not $blockOpen) {
                            'end {'
                            $blockOpen = $true
                        }
                        $StatementsToAdd -join [Environment]::NewLine
                        $StatementsToAdd = $null                        
                    }

                    if ($emptyBlockCount -ge $blocks.Length) {
                        $closeEndBlock = $false
                    }

                    # If we need to close the end block, and it is open,
                    if ($closeEndBlock -and $blockOpen) {
                        if ($block.Statements.Count) {
                        ' ' * ($block | MeasureIndent) + '}' #  close it.
                        } else {
                            '    }'
                        }
                    }
                } else {
                    $closeEndBlock = $false
                }
            }
        )

        $joinedScript = $joinScriptLines -join [Environment]::NewLine
        #endregion Joining the Scripts

        $combinedScriptBlock = [scriptblock]::Create($joinedScript)
        
        if ($combinedScriptBlock -and $Transpile) {
            $combinedScriptBlock | .>Pipescript
        } elseif ($combinedScriptBlock) {
            $combinedScriptBlock
        } else {
            $joinScriptLines -join [Environment]::NewLine
        }
    }
}
