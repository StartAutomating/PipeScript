<#
.Synopsis
    Inline Transpiler
.Description
    The PipeScript Core Inline Transpiler.  This makes Source Generators with inline PipeScript work.

    Regardless of underlying source language, a source generator works in a fairly straightforward way.

    Inline PipeScript will be embedded within the file (usually in comments).

    If a Regular Expression can match each section, then the content in each section can be replaced.
#>
param(

# A string containing the text contents of the file
[Parameter(Mandatory)]
[string]
$SourceText,

[Alias('Replace')]
[ValidateScript({    
    if ($_.GetGroupNames() -notcontains 'PS' -and 
        $_.GetGroupNames() -notcontains 'PipeScript'
    ) {
        throw "Group Name PS or PipeScript required"
    }
    return $true
})]
[regex]
$ReplacePattern,

# The Start Pattern.
# This indicates the beginning of what should be considered PipeScript.
# An expression will match everything until -EndPattern
[Alias('StartRegex')]
[Regex]
$StartPattern,

# The End Pattern
# This indicates the end of what should be considered PipeScript.
[Alias('EndRegex')]
[Regex]
$EndPattern,

# A custom replacement evaluator.
# If not provided, will run any embedded scripts encountered. 
# The output of these scripts will be the replacement text.
[Alias('Replacer')]
[ScriptBlock]
$ReplacementEvaluator,

# If set, will not transpile script blocks.
[switch]
$NoTranspile,

# The path to the source file.
[string]
$SourceFile,

# A Script Block that will be injected before each inline is run. 
[ScriptBlock]
$Begin,

# A Script Block that will be piped to after each output.
[Alias('Process')]
[ScriptBlock]
$ForeachObject,

# A Script Block that will be injected after each inline script is run. 
[ScriptBlock]
$End,

# A collection of parameters
[Collections.IDictionary]
$Parameter = @{},

# An argument list. 
[Alias('Args')]
[PSObject[]]
$ArgumentList = @(),

# Some languages only allow single-line comments.
# To work with these languages, provide a -LinePattern indicating what makes a comment
# Only lines beginning with this pattern within -StartPattern and -EndPattern will be considered a script.
[Regex]
$LinePattern
)

begin {
    function GetInlineScript($match) {
        $pipeScriptText = 
            if ($Match.Groups["PipeScript"].Value) {
                $Match.Groups["PipeScript"].Value
            } elseif ($match.Groups["PS"].Value) {
                $Match.Groups["PS"].Value                        
            }

        if (-not $pipeScriptText) {
            return
        }

        if ($LinePattern) {
            $pipeScriptLines = @($pipeScriptText -split '(?>\r\n|\n)')
            $pipeScriptText  = $pipeScriptLines -match $LinePattern -replace $LinePattern -join [Environment]::Newline
        }

        $InlineScriptBlock = [scriptblock]::Create($pipeScriptText)
        if (-not $InlineScriptBlock) {                    
            return
        }

        if (-not $NoTranspile) {
            $TranspiledOutput = $InlineScriptBlock | .>Pipescript
            if ($TranspiledOutput -is [ScriptBlock]) {
                $InlineScriptBlock = $TranspiledOutput
            }
        }
        $InlineScriptBlock
    }
}

process {
    
    if ($StartPattern -and $EndPattern) {
        # If the Source Start and End were provided,
        # create a replacepattern that matches all content until the end pattern.
        $ReplacePattern = [Regex]::New("
    # Match the PipeScript Start
    $StartPattern
    # Match until the PipeScript end.  This will be PipeScript
    (?<PipeScript>
    (?:.|\s){0,}?(?=\z|$endPattern)
    )
    # Then Match the PipeScript End
    $EndPattern
        ", 'IgnoreCase, IgnorePatternWhitespace', '00:00:10')

        # Now switch the parameter set to SourceTextReplace
        $psParameterSet = 'SourceTextReplace'
    }

    $newModuleSplat = @{ScriptBlock={}}
    if ($SourceFile) {
        $newModuleSplat.Name = $SourceFile
    }

    $FileModuleContext = New-Module @newModuleSplat

    # If the parameter set was SourceTextReplace
    if ($ReplacePattern) {
        $fileText      = $SourceText
        # See if we have a replacement evaluator.
        if (-not $PSBoundParameters["ReplacementEvaluator"]) {
            # If we don't, create one.
            $ReplacementEvaluator = {
                param($match)
                
                $InlineScriptBlock = GetInlineScript $match
                if (-not $InlineScriptBlock) { return }
                $inlineAstString = $InlineScriptBlock.Ast.Extent.ToString()
                if ($InlineScriptBlock.Ast.ParamBlock) {
                    $inlineAstString = $inlineAstString.Replace($InlineScriptBlock.Ast.ParamBlock.Extent.ToString(), '')
                }
                $inlineAstString = $inlineAstString
                $AddForeach =
                    $(
                        if ($ForeachObject) {
                            '|' + [Environment]::NewLine
                            @(foreach ($foreachStatement in $ForeachObject) {
                                if ($foreachStatement.Ast.ProcessBlock -or $foreachStatement.Ast.BeginBlock) {
                                    ". {$ForeachStatement}"
                                } elseif ($foreachStatement.Ast.EndBlock.Statements -and 
                                    $foreachStatement.Ast.EndBlock.Statements[0].PipelineElements[0].CommandElements -and
                                    $foreachStatement.Ast.EndBlock.Statements[0].PipelineElements[0].CommandElements.Value -in 'Foreach-Object', '%') {
                                    "$ForeachStatement"
                                } else {
                                    "Foreach-Object {$ForeachStatement}"
                                }
                            }) -join (' |' + [Environment]::NewLine)
                        }
                    )


                $statements = @(
                    if ($begin) {
                        "$begin"
                    }
                    if ($AddForeach) {
                        "@($inlineAstString)" + $AddForeach.Trim()
                    } else {
                        $inlineAstString
                    }
                    if ($end) {
                        "$end"
                    }
                ) 

                $codeToRun = [ScriptBlock]::Create($statements -join [Environment]::Newline)
                . $FileModuleContext { $match = $($args)} $match
                "$(. $FileModuleContext $codeToRun)"
            }
        }

        # Walk thru each match before we replace it
        foreach ($match in $ReplacePattern.Matches($fileText)) {
            # get the inline script block
            $inlineScriptBlock = GetInlineScript $match            
            if (-not $inlineScriptBlock -or # If there was no block or 
                # there were no parameters,
                -not $inlineScriptBlock.Ast.ParamBlock.Parameters 
            ) { 
                continue # skip.
            }
            # Create a script block out of just the parameter block
            $paramScriptBlock = [ScriptBlock]::Create(
                $inlineScriptBlock.Ast.ParamBlock.Extent.ToString()
            )
            # Dot that script into the file's context.
            # This is some wonderful PowerShell magic.
            # By doing this, the variables are defined with strong types and values.
            . $FileModuleContext $paramScriptBlock @Parameter @ArgumentList
        }

        # Now, we run the replacer.  
        # This should run each inline script and replace the text.        
        return $ReplacePattern.Replace($fileText, $ReplacementEvaluator)
    }
}

