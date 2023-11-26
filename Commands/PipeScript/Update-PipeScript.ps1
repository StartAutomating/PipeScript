function Update-PipeScript {
    <#
    .SYNOPSIS
        Updates PowerShell and PipeScript ScriptBlocks
    .DESCRIPTION
        Updates ScriptBlocks written in PowerShell or PipeScript.  Also updates blocks of text.

        Update-PipeScript is used by PipeScript transpilers in order to make a number of changes to a script.

        It can also be used interactively to transform scripts or text in a number of ways.
    .EXAMPLE
        Update-PipeScript -ScriptBlock {
            param($x,$y)
        } -RemoveParameter x
    .EXAMPLE
        Update-PipeScript -RenameVariable @{x='y'} -ScriptBlock {$x}
    .EXAMPLE
        Update-PipeScript -ScriptBlock {
            #region MyRegion
            1
            #endregion MyRegion
            2
        } -RegionReplacement @{MyRegion=''}            
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
    [Alias('ScriptReplacements','TextReplacements','ScriptReplacement', 'ReplaceText')]
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
    [Alias('AstReplacements', 'ReplaceAST')]
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

    [Collections.IDictionary]
    $AstCondition = [Ordered]@{},

    # If provided, will replace regular expression matches.
    [Alias('ReplaceRegex', 'RegexReplacements')]
    [Collections.IDictionary]
    $RegexReplacement = [Ordered]@{},

    # If provided, will replace regions.
    [Alias('ReplaceRegion')]
    [Collections.IDictionary]
    $RegionReplacement,

    # If provided, will remove one or more parameters from a ScriptBlock.
    [string[]]
    $RemoveParameter,

    # If provided, will insert text before any regular epxression match.
    [Collections.IDictionary]
    $InsertBefore,

    # If provided, will insert text after any regular expression match.
    [Collections.IDictionary]
    $InsertAfter,

    # A dictionary of items to insert after an AST element.
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
    $InsertAfterAST = [Ordered]@{},

    # A dictionary of items to insert before an AST element.
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
    $InsertBeforeAst = [Ordered]@{},

    # A dictionary of items to insert at the start of another item's AST block.
    # The key should be an AST element.
    # The nearest block start will be the point that the item is inserted.
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
    $InsertBlockStart = [Ordered]@{},

    # A dictionary of items to insert at the start of another item's AST block.
    # The key should be an AST element.
    # The nearest block end will be the point that the item is inserted.
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
    $InsertBlockEnd = [Ordered]@{},

    # A dictionary of text insertions.
    # The key is the insertion index.
    # The value is the insertion.    
    [ValidateScript({
        if (-not $_.Count) { return $true }
        $badKeys = $_.Keys -notmatch '^\d+$'
        if ($badKeys) {
            throw "-TextInsertion keys must be indexes: $badKeys"
        }
        return $true
    })]
    [Collections.IDictionary]
    $TextInsertion = [Ordered]@{},

    # A dictionary of regex based insertions
    # This works similarly to -RegexReplacement.
    [Alias('RegexInsertions')]
    [Collections.IDictionary]    
    $RegexInsertion = [Ordered]@{},

    # A collection of variables to rename.
    [Collections.IDictionary]
    [Alias('RenameParameter')]
    $RenameVariable,

    # Content to append.
    # Appended ScriptBlocks will be added to the last block of a ScriptBlock.
    # Appended Text will be added to the end.
    $Append,

    # Content to prepend
    # Prepended ScriptBlocks will be added to the first block of a ScriptBlock.
    # Prepended text will be added at the start.
    $Prepend,    

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
                $scriptBlockLines =@($scriptBlock -split '(?>\r\n|\n)')
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
        filter ReplaceWith {
            param($lineStartMatch)
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
        }
        # Declare a Regex to find the start of the line.
        $lineStart = [Regex]::new('(?>\r\n|\n|\A)', 'SingleLine,RightToLeft')
    }

    process {
        # If no text replacements were passed
        if (-not $TextReplacement) {
            $TextReplacement = [Ordered]@{} # initialize the collection
        }

        $null = New-Event -SourceIdentifier Update-PipeScript -MessageData ([Ordered]@{} + $PSBoundParameters)

        # The next series of things can only happen if we're dealing with a ```[ScriptBlock]```
        if ($ScriptBlock) {
            $Text = "$scriptBlock"
            $ScriptBlockOffset = $ScriptBlock.Ast.Extent.StartOffset
            #region Remove Parameter
            # If we're removing parameters,
            if ($RemoveParameter) {
                
                $index     = 0
                $AstCondition[{param($ast)
                    if ($ast -isnot [Management.Automation.Language.ParameterAst]) { return }
                    foreach ($toRemove in $RemoveParameter) {
                        if ($ast.name.variablePath -like $toRemove) {
                            return $true
                        }
                    }
                }] = {
                    param($paramToRemove)
                    # Determine where the parameter starts
                    $myOffset = [Math]::Max($paramToRemove.Extent.StartOffset - $ScriptBlockOffset - 2,0)
                    $start = $Text.IndexOf($paramToRemove.Extent.Text, $myOffset)
                    $end   = $start + $paramToRemove.Extent.Text.Length
                    if (([Collections.IList]$paramToRemove.Parent.Parameters).IndexOf($paramToRemove) -lt
                        $paramToRemove.Parent.Parameters.Count - 1) {
                        $end = $text.IndexOf(',', $end) + 1
                    } else {
                        $start = $text.LastIndexOf(",", $start)
                    }
                    @{"$start,$end" = ''}
                }
                <#
                # find them within the AST.
                $paramsToRemove = $ScriptBlock.Ast.FindAll({param($ast)
                    if ($ast -isnot [Management.Automation.Language.ParameterAst]) { return }
                    foreach ($toRemove in $RemoveParameter) {
                        if ($ast.name.variablePath -like $toRemove) {
                            return $true
                        }
                    }
                }, $true)

                # Walk over each parameter to turn it into a text replacement
                foreach ($paramToRemove in $paramsToRemove) {
                    # Determine where the parameter starts
                    $myOffset = [Math]::Max($paramToRemove.Extent.StartOffset - $ScriptBlockOffset - 2,0)
                    $start = $Text.IndexOf($paramToRemove.Extent.Text, $myOffset)
                    $end   = $start + $paramToRemove.Extent.Text.Length
                    if (([Collections.IList]$paramToRemove.Parent.Parameters).IndexOf($paramToRemove) -lt
                        $paramToRemove.Parent.Parameters.Count - 1) {
                        $end = $text.IndexOf(',', $end) + 1
                    } else {
                        $start = $text.LastIndexOf(",", $start)
                    }
                    $TextReplacement["$start,$end"] = ''
                }#>
            }
            #endregion Remove Parameter

            #region Rename Variables
            # If we're renaming variables or parameters
            if ($RenameVariable) {
                # this can be considered an -ASTCondition
                $AstCondition[{
                    param($ast)
                    if ($ast -isnot [Management.Automation.Language.VariableExpressionast]) { return $false }
                    if ($RenameVariable.Contains("$($ast.VariablePath)")) { return $true}
                    return $false   
                }] = {
                    param($var)
                    $renameToValue = $RenameVariable["$($var.VariablePath)"]
                    $replaceVariableText =
                        if ($var.Splatted) {
                            '@' + ($renameToValue -replace '^[\$\@]')
                        } else {
                            '$' + ($renameToValue -replace '^[\$\@]')
                        }

                    # Make a PSObject out of the replacement text
                    $replaceVariableText = [PSObject]::New($replaceVariableText)
                    # and add 'Inline' so that it renders correctly.
                    $replaceVariableText.PSObject.Properties.Add([PSNoteProperty]::New('Inline', $true))
                    $replaceVariableText
                }                                                
            }
            #endregion Rename Variables

            #region AST Conditions
            if ($AstCondition.Count) {
                $ScriptBlock.Ast.FindAll({
                    param($ast)
                    $conditionalReplacements =
                        @(if ($AstCondition.Contains($ast)) {                        
                            if ($AstCondition[$ast] -is [scriptblock]) {
                                & $AstCondition[$ast] $ast
                            } else {
                                $AstCondition[$ast]
                            }
                        }
                        else {
                            foreach ($astCond in $AstCondition.GetEnumerator()) {
                                if ($astCond.Key -is [scriptblock] -and
                                    (& $astCond.Key $ast)) {
                                    if ($astCond.Value -is [scriptblock]) {
                                        & $astCond.Value $ast
                                    }
                                    else {
                                        $astCond.Value
                                    }
                                }
                            }
                        })

                    # If there were any conditional replacement results
                    if ($conditionalReplacements) {
                        # we can interpret them two ways
                        
                        foreach ($conditionalReplacement in $conditionalReplacements) {
                            # If they were a dictionary, we can
                            if ($conditionalReplacement -is [Collections.IDictionary]) {                            
                                foreach ($conditionalReplaceOutput in $conditionalReplacement.GetEnumerator()) {
                                    if ($conditionalReplaceOutput.Key -is [Management.Automation.Language.Ast]) {
                                        $AstReplacement[$conditionalReplaceOutput.Key] = $conditionalReplaceOutput.Value
                                    }
                                    elseif ($conditionalReplaceOutput.Key -is [regex]) {
                                        $RegexReplacement[$conditionalReplaceOutput.Key] = $conditionalReplaceOutput.Value
                                    }
                                    elseif ($conditionalReplaceOutput.Key -match '^\d+,\d+$') {
                                        $TextReplacement[$conditionalReplaceOutput.Key] = $conditionalReplaceOutput.Value
                                    }
                                }
                            } else {
                                $AstReplacement[$ast] = $conditionalReplacement
                            }
                        }
                                                
                    }
                }, $true)
            }
            #endregion AST Conditions

            #region Replace AST
            # If we had any AST replacements
            if ($astReplacement.Count) {
                $index     = 0
                # sort them by their start.
                $sortedReplacements = @(
                    $astReplacement.GetEnumerator() |
                    Sort-Object { $_.Key.Extent.StartOffset } |
                    Select-Object -ExpandProperty Key
                )

                # Then, walk over each replacement
                foreach ($item in $sortedReplacements) {
                    # and turn it into a text range
                    $myOffset = [Math]::Max($item.Extent.StartOffset - $ScriptBlockOffset - 2,0)
                    $start = $Text.IndexOf($item.Extent.Text, $myOffset)
                    $end   = $start + $item.Extent.Text.Length
                    # then update the text replacements.
                    $TextReplacement["$start,$end"] = $astReplacement[$item]
                }
            }
            #endregion Replace AST
        }

        #region Replace Text Spans

        # Sort the replacements by their starting position.
        $enumReplacements = @($TextReplacement.GetEnumerator() | Sort-Object { @($_.Key -split ',')[0] -as [int] })
        $index     = 0
        $updatedText =
            @(
                # Walk thru each of the replacements
                for ($i = 0; $i -lt $enumReplacements.Count; $i++) {
                    # get their start and end index
                    $start, $end = $enumReplacements[$i].Key -split ',' -as [int[]]
                    # (if neither was defined, keep moving).
                    if (-not $start -and -not $end ) { continue }
                    # If the start of the replacement is greater than the current index
                    if ($start -gt $index) {
                        # get all text between here and there.
                        $Text.Substring($index, $start - $index)
                    }
                    # If the start was less than the index, we'd be replacing within what has already been replaced
                    elseif ($start -lt $index)
                    {
                        continue # so continue.
                    }

                    # Determine where the line starts (for indenting purposes),
                    $lineStartMatch = $lineStart.Match($text, $start)
                    # perform the replacement,
                    $enumReplacements[$i].Value | ReplaceWith -lineStartMatch $lineStartMatch
                    # and update the index.
                    $index = $end
                }

                # If there was any text remaining
                if ($index -lt $Text.Length) {
                    $Text.Substring($index) # include it as-is.
                }
            ) -join ''
        #endregion Replace Text Spans

        # Update $text before we continue
        $text = $updatedText        

        #region Replace Regions
        if ($RegionReplacement.Count) {
            # Region replacements are accomplished via a regular expression
            foreach ($regionName in $RegionReplacement.Keys) {
                $replacementReplacer = $RegionReplacement[$regionName]
                $RegionName = $RegionName -replace '\s', '\s'

                # We can create a Regex for each specific region,
                # thanks to [Irregular](https://github.com/StartAutomating/Irregular)
                $regionReplaceRegex = [Regex]::New("
                    [\n\r\s]{0,}        # Preceeding whitespace
                    \#region            # The literal 'region'
                    \s{1,}              # followed by at least one space.
                    (?<Name>$RegionName)
                        (?<Content>
                            (?:.|\s)+?(?=
                            \z|
                            ^\s{0,}\#endregion\s{1,}\k<Name>
                        )
                    )
                    ^\s{0,}\#endregion\s{1,}\k<Name>
                ", 'Multiline,IgnorePatternWhitespace,IgnoreCase', '00:00:05')
                $RegexReplacement[$regionReplaceRegex] = $replacementReplacer
            }
        }
        #endregion Replace Regions

        #region Replace Regex
        if ($RegexReplacement.Count) {
            foreach ($repl in $RegexReplacement.GetEnumerator()) {
                $replRegex = if ($repl.Key -is [Regex]) {
                    $repl.Key
                } else {
                    [Regex]::new($repl.Key,'IgnoreCase,IgnorePatternWhitespace','00:00:05')
                }
                $updatedText = $text = $replRegex.Replace($text, $repl.Value)
            }
        }
        #endregion Replace Regex
        
        #region Insertions

        #region Append and Prepend
        # Prepending and appending to text is easy:
        if (-not $ScriptBlock) {
            # Just prepend the text at the start
            if ($Prepend) {
                $TextInsertion["0"] = $Prepend -join [Environment]::NewLine
            }

            # and append anything at the end.
            if ($append) {
                $TextInsertion["$($text.Length - 1)"] = $Append -join [Environment]::NewLine
            }
        } else {
            # If we're prepending or appending to a ScriptBlock,
            $updatedScriptBlock = [ScriptBlock]::Create($updatedText)
            # the challenge is figuring out where we append or prepend.
            if ($updatedScriptBlock) {
                $ScriptBlock = $updatedScriptBlock
                $text = $updatedText = "$ScriptBlock"
            }
            
            $ScriptBlockAst = $ScriptBlock.Ast
            # If the [ScriptBlock] is a function definition, 
            if ($ScriptBlockAst.Body) {
                $ScriptBlockAst = $ScriptBlockAst.Body # look in it's body
            }

            # List all of the named blocks, in order
            $potentialInsertLocations = @(
                $ScriptBlockAst.ParamBlock,
                $ScriptBlockAst.DynamicParamBlock,
                $ScriptBlockAst.BeginBlock,
                $ScriptBlockAst.ProcessBlock,
                $ScriptBlockAst.EndBlock -ne $null
            ) # (and force what is not null into an array).

            # Walk thru each prepend
            foreach ($pre in $Prepend) {
                $potentialInsertAst = $null
                $potentialInsert =
                    # If we are prepending a ScriptBlock
                    if ($pre -is [scriptblock]) {                        
                        foreach ($potentialInsert in $potentialInsertLocations) {
                            # it cannot go in the param block
                            if ($potentialInsert -is [Management.Automation.Language.ParamBlockAst]) {
                                continue
                            }
                            $potentialInsertAst = $potentialInsert
                            # and we'd like to put it before the first statement in the first block.
                            @($potentialInsert.Statements)[0]
                            break                            
                        }
                    } else {
                        # If we're prepending text, it should go before the block                        
                        $potentialInsertAst = $potentialInsertLocations[0]
                        $potentialInsertAst
                    }

                # If we could not find an insertion statement
                if (-not $potentialInsert) {
                    # the block is empty, so find it's start
                    $match = [Regex]::new("$($potentialInsertAst.BlockKind)\s{0,}\{\s{0,}",'IgnoreCase').Match($Text,
                        [Math]::Max(
                            $potentialInsertAst.Extent.StartOffset - $ScriptBlockAst.StartOffset - 5, 0
                        )
                    )
                    
                    if ($match.Success) {
                        # Turn this into an index, and then set -TextInsertion at that point.
                        $insertAt = $match.Index + $match.Length
                        if (-not $TextInsertion["$insertAt"]) {
                            $TextInsertion["$insertAt"] = @($pre)
                        } else {
                            $TextInsertion["$insertAt"] += $pre
                        }                        
                    }
                } else {
                    # Otherwise, use -InsertBeforeAst
                    if (-not $InsertBeforeAst[$potentialInsert]) {
                        $InsertBeforeAst[$potentialInsert] = @($pre)
                    } else {
                        $InsertBeforeAst[$potentialInsert] += $pre
                    }
                }
            }

            # If we're appending
            foreach ($app in $append) {
                # Find the last statement in the last block
                $statementList = @($potentialInsertLocations[-1].Statements)
                $potentialInsert = $statementList[-1]
                # If no statement was found, find the last block
                if (-not $potentialInsert) {
                    $match = [Regex]::new("$($potentialInsertLocations[-1].BlockKind)\s{0,}\{\s{0,}",'IgnoreCase').Match($Text,
                        [Math]::Max(
                            $potentialInsertLocations[-1].Extent.StartOffset - $ScriptBlockAst.StartOffset - 5, 0
                        )
                    )
                    if ($match.Success) {
                        # and use -TextInsertion at that location.
                        $insertAt = $match.Index + $match.Length
                        if (-not $TextInsertion["$insertAt"]) {
                            $TextInsertion["$insertAt"] = @($app)
                        } else {
                            $TextInsertion["$insertAt"] += $app
                        }                        
                    }                    
                } else {
                    # If a statement was found, insert after that point.
                    if (-not $InsertAfterAst[$potentialInsert]) {
                        $InsertAfterAst[$potentialInsert] = $App
                    } else {
                        $InsertAfterAst[$potentialInsert] += $App
                    }
                }
            }                            

        }
        #endregion Append and Prepend

        #region InsertBlockStart
        if ($InsertBlockStart.Count) {
            foreach ($item in @(
                $InsertBlockStart.GetEnumerator() |
                Sort-Object { $_.Key.Extent.StartOffset }
            )) {
                $astItem = $item.Key
                while ($astItem -and $astItem -isnot [Management.Automation.Language.NamedBlockAst]) {
                    $astItem = $astItem.Parent
                }
                if ($astItem -is [Management.Automation.Language.NamedBlockAst]) {
                    $astBlockKind = if ($astItem.Unnamed) {
                        ''
                    } else {
                        $astItem.BlockKind
                    }
                    $match = [Regex]::new("$astBlockKind\s{0,}\{\s{0,}",'IgnoreCase').Match($Text,
                        [Math]::Max(
                            $potentialInsertLocations[-1].Extent.StartOffset - $ScriptBlockAst.StartOffset - 5, 0
                        )
                    )
                    $insertAt = 
                        if ($match.Success) {
                            # and use -TextInsertion at that location.
                            $match.Index + $match.Length
                        } else {
                            0
                        }
                    
                    if (-not $TextInsertion["$insertAt"]) {
                        $TextInsertion["$insertAt"] = @($item.Value)
                    } else {
                        $TextInsertion["$insertAt"] += $item.Value
                    }                        
                    
                }
            }
        }
        #endregion InsertBlockStart
        
        #region InsertBlockEnd
        if ($InsertBlockEnd.Count) {
            foreach ($item in @(
                $InsertBlockEnd.GetEnumerator() |
                Sort-Object { $_.Key.Extent.StartOffset }
            )) {
                $astItem = $item.Key
                while ($astItem -and $astItem -isnot [Management.Automation.Language.NamedBlockAst]) {
                    $astItem = $astItem.Parent
                }
                if ($astItem -is [Management.Automation.Language.NamedBlockAst]) {
                    # If we're in a named block, there _really_ should be statements.
                    $insertPoint = $astItem.Statements[-1]
                    if ($insertPoint) {
                        if (-not $InsertAfterAst[$insertPoint]) {
                            $InsertAfterAst[$insertPoint] = $item.Value
                        } else {
                            $InsertAfterAst[$insertPoint] = @($InsertAfterAst[$insertPoint]) + $item.Value
                        }                         
                    }                    
                }
            }
        }
        #endregion InsertBlockEnd

        #region Insert Before AST
        # If we had any AST insertions
        if ($InsertBeforeAst.Count) {
            $index     = 0
            # sort them by their start.
            foreach ($item in @(
                $InsertBeforeAst.GetEnumerator() |
                Sort-Object { $_.Key.Extent.StartOffset } |
                Select-Object -ExpandProperty Key
            )) {
                # and turn it into a text range
                $myOffset = [Math]::Max($item.Extent.StartOffset - $ScriptBlockOffset - 2,0)
                $start = $Text.IndexOf($item.Extent.Text, $myOffset)       
                # then update the text replacements.
                if (-not $TextInsertion["$($start - 1)"]) {
                    $TextInsertion["$($start - 1)"] = @($InsertBeforeAst[$item])
                } else {
                    $TextInsertion["$($start - 1)"] += @($InsertBeforeAst[$item])
                }
            }
        }
        #endregion Insert Before AST

        #region Insert After AST
        # If we had any AST insertions
        if ($InsertAfterAst.Count) {            
            $index     = 0
            # sort them by their start.
            foreach ($item in @(
                $InsertAfterAST.GetEnumerator() |
                Sort-Object { $_.Key.Extent.StartOffset } |
                Select-Object -ExpandProperty Key
            )) {
                # and turn it into a text range
                $myOffset = [Math]::Max($item.Extent.StartOffset - $ScriptBlockOffset - 2,0)
                $start = $Text.IndexOf($item.Extent.Text, $myOffset)
                $end   = $start + $item.Extent.Text.Length
                # then update the text replacements.
                if (-not $TextInsertion["$end"]) {
                    $TextInsertion["$end"] = @($InsertAfterAST[$item])
                } else {
                    $TextInsertion["$end"] += @($InsertAfterAST[$item])
                }            
            }
        }
        #endregion Insert After AST

        
        # If we had any text insertions
        if ($TextInsertion.Count) {
            # keep track of how much we insert
            $insertedLength = 0
            foreach ($kv in $TextInsertion.GetEnumerator()) {
                $offset = [Math]::Max(($kv.Key -as [int]), 0)
                # find the indenting for the line                
                $lineStartMatch = $lineStart.Match($text, $offset + $insertedLength)
                # and perform the replacement                
                $insertion = $kv.Value | ReplaceWith -lineStartMatch $lineStartMatch
                if ($ScriptBlock) {
                    # (if we're in a ScriptBlock, surround our replacement with newlines so it remains valid)
                    $insertion = [Environment]::NewLine + "$insertion" + [Environment]::NewLine
                }

                # Update the text
                $text = $updatedText = $updatedText.Insert($offset + $insertedLength, $insertion)
                # and update our insertsion length.
                $insertedLength += $insertion.Length
            }
        }


        # If we have any -InsertBefore 
        if ($InsertBefore.Count) {
            # Walk thru each insertion
            foreach ($kv in @($InsertBefore.GetEnumerator())) {                
                if (                    
                    $kv.Value -is [string] -and # If the value was a string and
                    -not $kv.Value.Contains('$&') # it did not include the substitution.
                ) {
                    $kv.Value += '$&' # substitute the match at the end.
                }
                # Add our insertion to the regular expression replacements.
                $RegexInsertion[$kv.Key] = $kv.Value
            }
        }

        # If we had any -InsertAfter
        if ($InsertAfter.Count) {
            # Walk thru each insertion
            foreach ($kv in @($InsertAfter.GetEnumerator())) {
                if (                    
                    $kv.Value -is [string] -and # If the value was a string and
                    -not $kv.Value.Contains('$&') # it did not include the substitution.
                ) {
                    $kv.Value = '$&' + $kv.Value # substitute the match at the start.
                }
                # Add our insertion to the regular expression replacements.
                $RegexInsertion[$kv.Key] = $kv.Value
            }
        }
        #endregion Insert Before/After

        #region Insert Regex
        if ($RegexInsertion.Count) {
            foreach ($repl in $RegexInsertion.GetEnumerator()) {
                $replRegex = if ($repl.Key -is [Regex]) {
                    $repl.Key
                } else {
                    [Regex]::new($repl.Key,'IgnoreCase,IgnorePatternWhitespace','00:00:05')
                }
                $updatedText = $text = $replRegex.Replace($text, $repl.Value)
            }
        }
        #endregion Insert Regex

        #endregion

        if ($ScriptBlock) {
            $updatedScriptBlock = [ScriptBlock]::Create($updatedText)
            if ($Transpile) {
                $updatedScriptBlock | .>Pipescript
            } else {
                $updatedScriptBlock
            }
        } else {
            $updatedText
        }
    }
}
