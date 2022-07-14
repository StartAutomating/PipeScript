function Join-PipeScript
{
    <#
    .SYNOPSIS
        Joins PowerShell and PipeScript ScriptBlocks
    .DESCRIPTION
        Joins ScriptBlocks written in PowerShell or PipeScript.
    .EXAMPLE
        Get-Command Join-PipeScript | Join-PipeScript
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

    # A list of block types to be skipped during a merge of script blocks.
    # By default, no blocks will be skipped
    [ValidateSet('using', 'requires', 'help','param','dynamicParam','begin','process','end')]
    [string[]]
    $SkipBlockType,

    # A list of block types to include during a merge of script blocks.
    [ValidateSet('using', 'requires', 'help','param','dynamicParam','begin','process','end')]
    [string[]]
    $BlockType = @('using', 'requires', 'help','param','dynamicParam','begin','process','end'),

    # If set, will transpile the joined ScriptBlock.    
    [switch]
    $Transpile
    )

    begin {
        $AllScriptBlocks = @()
        
        filter IndentAst {
            $ast = $_            
            (' ' * ($ast | MeasureIndent)) + "$($ast.Extent)"    # combine the statements a newline.            
        }

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
        if ($ScriptBlock) {
            $AllScriptBlocks += $ScriptBlock
        }
    }

    end {
        if ($SkipBlockType) {
            foreach ($skipBlock in $SkipBlockType) {
                if ($blockType -contains $skipBlock) {
                    $blockType = $BlockType -ne $skipBlock
                }
            }
        }
        $AllScriptBlocks  = @(
        foreach ($toMerge in $AllScriptBlocks) {
            if ($toMerge.Ast.body) {
                [ScriptBlock]::Create($toMerge.Ast.Body.Extent.ToString() -replace '^\{' -replace '\}$')
            } else {
                $toMerge
            }
        })


        $mergedScript = @(
            if ($BlockType -contains 'using') {
                foreach ($usingStatement in $AllScriptBlocks.Ast.UsingStatements) {
                    $usingStatement.Extent.ToString()
                }                
            }

            if ($BlockType -contains 'requires') {
                foreach ($requirement in $AllScriptBlocks.Ast.ScriptRequirements) {
                    if ($requirement.RequirementPSVersion) {
                        "#requires -Version $($requirement.RequirementPSVersion)"
                    }
                    if ($requirement.IsElevationRequired) {
                        "#requires -RunAsAdministrator"
                    }
                    if ($requirement.RequiredModules) {
                        "#requires -Module $(@(foreach ($reqModule in $requirement.RequiredModules) {
                            if ($reqModule.Version -or $req.RequiredVersion -or $req.MaximumVersion) {
                                '@{' + $(@(foreach ($prop in $reqModule.PSObject.Properties) {
                                    if (-not $prop.Value) { continue }
                                    if ($prop.Name -in 'Name', 'Version') {
                                        "Module$($prop.Name)='$($prop.Value.ToString().Replace("'","''"))'"
                                    } elseif ($prop.Name -eq 'RequiredVersion') {
                                        "MinimumVersion='$($prop.Value)'" 
                                    } else {
                                        "$($prop.Name)='$($prop.Value)'" 
                                    }
                                }) -join ';') + '}'
                            } else {
                                $reqModule.Name
                            }
                        }) -join ',')"
                    }
                    if ($requirement.RequiredAssemblies) {
                        "#requires -Assembly $($requirement.RequiredAssemblies -join ',')"
                    }
                }
            }

            if ($BlockType -contains 'param') {
                foreach ($combined in $AllScriptBlocks.Ast.ParamBlock) {
                    if (-not $combined.Parent.Extent) { continue }
                    $offsetDifference = $combined.Extent.StartOffset - $combined.Parent.Extent.StartOffset
                    $combined.Parent.Extent.ToString().Substring(0, $offsetDifference) -replace '^[\r\n]+\{'
                }
            }            
            # Start the param block
            
            $alreadyIncludedParameter = [Ordered]@{}
            if ($BlockType -contains 'param') {
                if (@($AllScriptBlocks.Ast.ParamBlock) -ne $null) {
                    ' ' * (@(@($AllScriptBlocks.Ast.ParamBlock) -ne $null)[0] | MeasureIndent) + "param("
                }                    
                $paramOut = @(
                foreach ($combined in $AllScriptBlocks.Ast.ParamBlock) {
                    # Include any existing parameters                        
                    $parameterIndex  = 0
                    foreach ($parameter in $combined.parameters) {
                        $variableName = $parameter.Name.VariablePath.ToString()
                    
                        $inlineParameterHelp =
                            if ($parameterIndex -gt 0) {
                                $lastParameter   = $parameter.Parent.Parameters[$parameterIndex - 1]
                                $relativeOffset  = $lastParameter.Extent.EndOffset + 1 - $parameter.Parent.Extent.StartOffset
                                $distance        = $parameter.Extent.StartOffset - $lastParameter.Extent.EndOffset - 1
                                $parameter.Parent.Extent.ToString().Substring($relativeOffset, $distance) -replace '^[\,\s\r\n]+'
                            } else {
                                $parentExtent = $parameter.Parent.Extent.ToString()
                                $afterFirstParens = $parentExtent.IndexOf('(') + 1 
                                $parentExtent.Substring($afterFirstParens, 
                                    $parameter.Extent.StartOffset - $parameter.Parent.Extent.StartOffset - $afterFirstParens) -replace '^[\s\r\n]+'
                            }


                        if (-not $alreadyIncludedParameter[$variableName]) {
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
                $paramOut -notmatch '^[\s\r\n]$' -join (',' + ([Environment]::NewLine * 2))
                if (@($AllScriptBlocks.Ast.ParamBlock) -ne $null) {
                    ' ' * (@(@($AllScriptBlocks.Ast.ParamBlock) -ne $null)[0] | MeasureIndent) + ")"
                }            
            }

            if ($BlockType -contains 'dynamicParam') {
                $blocks = @($AllScriptBlocks.Ast.DynamicParamBlock)
                if ($blocks -ne $null) {
                    $blockOpen = $false
                    foreach ($block in $blocks) {
                        if (-not $block) { continue }
                        if (-not $blockOpen) {
                            ($block | IndentAst) -replace '\}$'
                            $blockOpen = $true
                        } else {
                            $block.Extent.ToString() -replace '^dynamicParam\s{0,}\{' -replace '\}$'
                        }
                    }
                    ' ' * ($block | MeasureIndent) + '}'
                }
            }
            

            
            if ($BlockType -contains 'begin') {  # If there were begin blocks,
                $blocks = @($AllScriptBlocks.Ast.BeginBlock)
                if ($blocks -ne $null) {
                    $blockOpen = $false
                    foreach ($block in $blocks) {
                        if (-not $block) { continue }
                        if (-not $blockOpen) {
                            ($block | IndentAst) -replace '\}$'
                            $blockOpen = $true
                        } else {
                            $block.Extent.ToString() -replace '^begin\s{0,}\{' -replace '\}$'
                        }
                    }
                    ' ' * ($block | MeasureIndent) + '}'
                }                
            }

            if ($BlockType -contains 'process') {  # If there were process blocks
                $blocks = @($AllScriptBlocks.Ast.ProcessBlock)
                if ($blocks -ne $null) {
                    $blockOpen = $false
                    foreach ($block in $blocks) {
                        if (-not $block) { continue }
                        if (-not $blockOpen) {
                            ($block | IndentAst) -replace '\}$'
                            $blockOpen = $true
                        } else {
                            $block.Extent.ToString() -replace '^process\s{0,}\{' -replace '\}$'
                        }
                    }
                    ' ' * ($block | MeasureIndent) + '}'
                }
            }

            if ($BlockType -contains 'end') {
                # If there were end blcoks declared
                
                $blocks = @($AllScriptBlocks.Ast.EndBlock)
                if ($blocks -ne $null) {
                    $blockOpen = $false
                    foreach ($block in $blocks) {
                        if (-not $block) { continue }
                        if (-not $blockOpen -and -not $block.Unnamed) {
                            ($block | IndentAst) -replace '\}$'
                            $blockOpen = $true
                        } elseif ($block.Statements.Count) {
                            $block.Extent.ToString() -replace '^end\s{0,}\{' -replace '\}$' -replace '^param\(\)[\s\r\n]{0,}'
                        }
                    }
                    if ($beginOrProcess -ne $null) {
                        ' ' * ($block | MeasureIndent) + '}'
                    }
                }
            }
        )

        $combinedScriptBlock = [scriptblock]::Create($mergedScript -join [Environment]::NewLine)
        if ($combinedScriptBlock -and $Transpile) {
            $combinedScriptBlock | .>Pipescript
        } elseif ($combinedScriptBlock) {
            $combinedScriptBlock
        } else {
            $mergedScript -join [Environment]::NewLine
        }
    }
}
