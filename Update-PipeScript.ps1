function Update-PipeScript {
    <#
    .SYNOPSIS
        Updates PowerShell and PipeScript ScriptBlocks
    .DESCRIPTION
        Updates ScriptBlocks written in PowerShell or PipeScript.  Also updates blocks of text.

        Update-PipeScript is used by PipeScript transpilers in order to make a number of changes to a script.

        It can also be used interactively to transform scripts or text in a number of ways.        
    #>
    [Alias('Update-ScriptBlock', 'ups')]
    param(    
    # A Script Block, written in PowerShell or PipeScript.
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [Alias('Definition')]
    [ScriptBlock]
    $ScriptBlock,
    
    # A block of text.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Text,

    # Replaces sections within text.  -TextReplacement is a dictionary of replacements.
    # Keys in the dictionary must be a string describing a character range, in the form start,end.
    [Alias('ScriptReplacements','TextReplacements','ScriptReplacement')]
    [ValidateScript({
        if (-not $_.Count) { return $true }
        $badKeys = $_.Keys -notmatch '^\d+,\d+$'
        if ($badKeys) {
            throw "-TextReplacement contains bad keys: $badKeys"
        }
        return $true
    })]
    [Collections.IDictionary]
    $TextReplacement,    

    # If set, will replace items based off of the abstract syntax tree.
    [Alias('AstReplacements')]
    [ValidateScript({
        $badKeys = 
            foreach ($k in $_.Keys) { 
                if ($k -isnot [Management.Automation.Language.Ast]) {
                    $k
                }            
            }
        if ($badKeys) {
            throw "-AstReplacement contains bad keys: $badKeys"
        }
        return $true
    })]
    [Collections.IDictionary]
    $AstReplacement = [Ordered]@{},
    
    # If provided, will remove one or more parameters from a ScriptBlock.
    [string[]]
    $RemoveParameter,
    
    # A collection of variables to rename.
    [Collections.IDictionary]
    $RenameVariable,

    # If set, will transpile the updated script block.
    [switch]
    $Transpile
    )

    begin {
        
        # Code gets a lot more readable when it matches indentation.
        function IndentScriptBlock {
            param(
            [Parameter(ValueFromPipeline)]
            $ScriptBlock,
        
            [int]
            $Indent,
        
            [switch]
            $IndentFirstLine
            )
        
            process {
                $scriptBlockLines =@($scriptBlock -split '[\r\n]+')
                if ($scriptBlockLines.Length -eq 1) { return $ScriptBlock }
                $InHereDoc = $false
                $IsFirstLine = $true
                $newScriptBlock = 
                    @(foreach ($scriptBlockLine in $scriptBlockLines) {
                        if ($IsFirstLine) {
                            if (-not $IndentFirstLine) {
                                $scriptBlockLine
                            } else {
                                (' ' * $Indent) + $scriptBlockLine                        
                            }
                            
                            $IsFirstLine = $false
                        }
                        else {
                            if (-not $InHereDoc) {
                                (' ' * $Indent) + $scriptBlockLine
                            } else {
                                $scriptBlockLine
                            }
                        }
                        if ($scriptBlockLine -match '@["'']$') {
                            $InHereDoc = $true
                        } elseif ($scriptBlockLine -match '^["'']@') {
                            $InHereDoc = $false
                        }
                    }) -join [Environment]::NewLine
                [scriptblock]::Create($newScriptBlock)
            }
        }
        
    }

    process {
        # If no text replacements were passed
        if (-not $TextReplacement) {
            $TextReplacement = [Ordered]@{} # initialize the collection
        }
        
        # The next series of things can only happen if we're dealing with a ```[ScriptBlock]```
        if ($ScriptBlock) {
            $Text = "$scriptBlock"
            
            # If we're removing parameters
            if ($RemoveParameter) {
                $myOffset  = 0
                $index     = 0
                # Find them within the AST.
                $paramsToRemove = $ScriptBlock.Ast.FindAll({param($ast)
                    if ($ast -isnot [Management.Automation.Language.ParameterAst]) { return }
                    foreach ($toRemove in $RemoveParameter) {                        
                        if ($ast.name.variablePath -like $toRemove) {
                            return $true
                        }
                    }
                }, $true)
                
                foreach ($paramToRemove in $paramsToRemove) {
                    $start = $Text.IndexOf($paramToRemove.Extent.Text, $myOffset)
                    $end   = $start + $paramToRemove.Extent.Text.Length
                    if (([Collections.IList]$paramToRemove.Parent.Parameters).IndexOf($paramToRemove) -lt 
                        $paramToRemove.Parent.Parameters.Count - 1) {
                        $end = $text.IndexOf(',', $end) + 1
                    } else {
                        $start = $text.LastIndexOf(",", $start)
                    }
                    $TextReplacement["$start,$end"] = ''
                    $myOffset = $end
                }
            }
            

            if ($RenameVariable) {
                $variablesToRename = @($ScriptBlock.Ast.FindAll({
                    param($ast)
                    if ($ast -isnot [Management.Automation.Language.VariableExpressionast]) { return $false }                
                    if ($RenameVariable.Contains("$($ast.VariablePath)")) { return $true}
                    return $false
                }, $true))
                
                $myOffset = 0
                foreach ($var in $variablesToRename) {
                    $renameToValue = $RenameVariable["$($var.VariablePath)"]
                    $replaceVariableText = 
                        if ($var.Splatted) {
                            '@' + ($renameToValue -replace '^[\$\@]')
                        } else {
                            '$' + ($renameToValue -replace '^[\$\@]')
                        }
                    $replaceVariableText = [PSObject]::New($replaceVariableText)
                    $replaceVariableText.PSObject.Properties.Add([PSNoteProperty]::New('Inline', $true))
                    $astReplacement[$var] = $replaceVariableText                                        
                    $myOffset = $end
                }
            }
            
            
            if ($astReplacement.Count) {
                $myOffset  = 0
                $index     = 0
                $sortedReplacements = @(
                    $astReplacement.GetEnumerator() | 
                    Sort-Object { $_.Key.Extent.StartOffset } | 
                    Select-Object -ExpandProperty Key
                )
                
                foreach ($item in $sortedReplacements) {
                    $start = $Text.IndexOf($item.Extent.Text, $myOffset)
                    $end   = $start + $item.Extent.Text.Length
                    $TextReplacement["$start,$end"] = $astReplacement[$item]
                    $myOffset = $end
                }
            }            
        }
                
        $enumReplacements = @($TextReplacement.GetEnumerator() | Sort-Object { @($_.Key -split ',')[0] -as [int] })
        $index     = 0 
        $lineStart = [Regex]::new('(?>\r\n|\n|\A)', 'SingleLine,RightToLeft')
        $newScript = 
            @(
                for ($i = 0; $i -lt $enumReplacements.Count; $i++) {
                    $start, $end = $enumReplacements[$i].Key -split ',' -as [int[]]
                    if (-not $start -and -not $end ) { continue }
                    if ($start -gt $index) {
                        $Text.Substring($index, $start - $index)
                    } elseif ($start -lt $index) {
                        # If the start was less than the index, we'd be replacing within what has already been replaced,
                        continue # so continue.
                    }
                    $lineStartMatch = $lineStart.Match($text, $start)
                    $enumReplacements[$i].Value |
                        & { process { 
                            $in = $_
                            if ($in -is [string] -and $in) {
                                if ($ScriptBlock -and -not $in.Inline) {
                                '@''' + [Environment]::NewLine + $in + [Environment]::NewLine + '''@' 
                                } else {
                                    $in    
                                }
                            } 
                            elseif ($in -is [boolean]) {
                                if ($ScriptBlock) {
                                    "`$$in"
                                } else {
                                    "$in".ToLower()
                                }
                            }
                            elseif ($in.GetType -and $in.GetType().IsPrimitive) {
                                $in
                            }
                            elseif ($in -is [ScriptBlock]) {
                                $indentLevel = $start - $lineStartMatch.Index - $lineStartMatch.Length
                                $in = IndentScriptBlock -ScriptBlock $in -Indent $indentLevel
                                # If the script block is has an empty parameter block at the end
                                if ($in.Ast.Extent -match 'param\(\)[\s\r\n]{0,}$') {
                                    # embed everything before that block.
                                    $in.Ast.Extent -replace 'param\(\)[\s\r\n]{0,}$'
                                } else {
                                    # otherwise, embed the block.
                                    
                                    $in
                                }
                            }
                        } } 
                    $index = $end
                }
                if ($index -lt $Text.Length) {
                    $Text.Substring($index)
                }
            ) -join ''

            if ($ScriptBlock) {                
                if ($Transpile) {
                    [ScriptBlock]::Create($newScript) | .>Pipescript
                } else {
                    [ScriptBlock]::Create($newScript)
                }
            } else {
                $newScript
            }
    }
}
