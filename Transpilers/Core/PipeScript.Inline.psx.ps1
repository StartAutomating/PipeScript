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
[Parameter(Mandatory,ParameterSetName='SourceTextReplace')]
[Parameter(Mandatory,ParameterSetName='SourceStartAndEnd')]
[string]
$SourceText,

[Parameter(Mandatory,ParameterSetName='SourceTextReplace')]
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
[Parameter(Mandatory,ParameterSetName='SourceStartAndEnd')]
[Alias('StartRegex')]
[Regex]
$StartPattern,

# The End Pattern
# This indicates the end of what should be considered PipeScript.
[Parameter(Mandatory,ParameterSetName='SourceStartAndEnd')]
[Alias('EndRegex')]
[Regex]
$EndPattern,

[Parameter(ParameterSetName='SourceTextReplace')]
[Parameter(ParameterSetName='SourceStartAndEnd')]
[Alias('Replacer')]
[ScriptBlock]
$ReplacementEvaluator,

# If set, will not transpile script blocks.
[Parameter(ParameterSetName='SourceStartAndEnd')]
[Parameter(ParameterSetName='SourceTextReplace')]
[switch]
$NoTranspile,

# The path to the source file.
[Parameter(ParameterSetName='SourceTextReplace')]
[Parameter(ParameterSetName='SourceStartAndEnd')]
[string]
$SourceFile,

# A Script Block that will be injected before each inline is run. 
[Parameter(ParameterSetName='SourceTextReplace')]
[Parameter(ParameterSetName='SourceStartAndEnd')]
[ScriptBlock]
$Begin,

# A Script Block that will be piped to after each output.
[Parameter(ParameterSetName='SourceTextReplace')]
[Parameter(ParameterSetName='SourceStartAndEnd')]
[Alias('Process')]
[ScriptBlock]
$ForeachObject,

# A Script Block that will be injected after each inline script is run. 
[Parameter(ParameterSetName='SourceTextReplace')]
[Parameter(ParameterSetName='SourceStartAndEnd')]
[ScriptBlock]
$End
)

begin {
    $TempModule = New-Module -ScriptBlock { }
}

process {
    $psParameterSet = $psCmdlet.ParameterSetName
    if ($psParameterSet -eq 'SourceStartAndEnd') {
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
        $psParameterSet = 'SourceTextReplace'
    }

    if ($psParameterSet -eq 'SourceTextReplace') {
        $fileText      = $SourceText
        if (-not $PSBoundParameters["ReplacementEvaluator"]) {
            $ReplacementEvaluator = {
                param($match)

                $pipeScriptText = 
                    if ($Match.Groups["PipeScript"].Value) {
                        $Match.Groups["PipeScript"].Value
                    } elseif ($match.Groups["PS"].Value) {
                        $Match.Groups["PS"].Value                        
                    }

                if (-not $pipeScriptText) {
                    return
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
                
                $inlineAstString = $InlineScriptBlock.Ast.Extent.ToString()
                if ($InlineScriptBlock.ParamBlock) {
                    $inlineAstString = $inlineAstString.Replace($InlineScriptBlock.ParamBlock.Extent.ToString(), '')
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

                "$(. $TempModule $codeToRun)"
            }
        }

        return $ReplacePattern.Replace($fileText, $ReplacementEvaluator)
    }
}

