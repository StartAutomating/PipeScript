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

    # If provided, will replace regular expression matches.
    [Collections.IDictionary]
    $RegexReplacement = [Ordered]@{},

    # If provided, will replace regions.
    [Collections.IDictionary]
    $RegionReplacement,

    # If provided, will remove one or more parameters from a ScriptBlock.
    [string[]]
    $RemoveParameter,

    # A collection of variables to rename.
    [Collections.IDictionary]
    [Alias('RenameParameter')]
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

        # The next series of things can only happen if we're dealing with a ```[ScriptBlock]```
        if ($ScriptBlock) {
            $Text = "$scriptBlock"

            #region Remove Parameter
            # If we're removing parameters,
            if ($RemoveParameter) {
                $myOffset  = 0
                $index     = 0
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
                    # Determine where th parameter starts
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
            #endregion Remove Parameter

            #region Rename Variables
            # If we're renaming variables or parameters
            if ($RenameVariable) {
                # Find all of the variable references
                $variablesToRename = @($ScriptBlock.Ast.FindAll({
                    param($ast)
                    if ($ast -isnot [Management.Automation.Language.VariableExpressionast]) { return $false }
                    if ($RenameVariable.Contains("$($ast.VariablePath)")) { return $true}
                    return $false
                }, $true))

                # Walk over each variable we have to rename.
                foreach ($var in $variablesToRename) {
                    #
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
                    # then add our replacement to $astReplacement.
                    $astReplacement[$var] = $replaceVariableText
                }
            }
            #endregion Rename Variables

            #region Replace AST
            # If we had any AST replacements
            if ($astReplacement.Count) {
                $myOffset  = 0
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
                    $start = $Text.IndexOf($item.Extent.Text, $myOffset)
                    $end   = $start + $item.Extent.Text.Length
                    # then update the text replacements.
                    $TextReplacement["$start,$end"] = $astReplacement[$item]
                    $myOffset = $end
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
                $newScript = $text = $replRegex.Replace($text, $repl.Value)
            }
        }
        #endregion Replace Regex

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
