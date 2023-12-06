<#
.Synopsis
    Template Transpiler
.Description
    The PipeScript Core Template Transpiler.
    
    This allows PipeScript to generate many other languages.

    Regardless of the underlying language, the core template transpiler works in a fairly straightforward way.

    A language will contain PipeScript within the file (usually in comments).
    
    If a Regular Expression can match each section, then the content in each section can be replaced.

    When a file that can be transpiled is encountered,
    the template transpiler for that file type will call the core template transpiler.

    When templates are used as a keyword,
    the template transpiler will produce an object that can evaluate the template on demand.
#>

[ValidateScript({
    $validating = $_
    if ($validating -isnot [Management.Automation.Language.CommandAst]) {
        # Leave non-AST commands alone for the moment.
    } else {
        # For CommandASTs, make a list of the barewords
        $barewords =
            @(foreach ($cmdElement in $validating.CommandElements) {
                if ($cmdElement.StringConstantType -ne 'Bareword') { break }
                $cmdElement.Value
            })
        
        # If one of the first two barewords was 'template
        if ($barewords[0..1] -eq 'template') {
            return $true # return true (and run this transpiler)
        }
        # Otherwise, return false.
        return $false
    }
})]
[Reflection.AssemblyMetaData('Order', -1)]
param(
# A string containing the text contents of the file
[Parameter()]
[Alias('TemplateText')]
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

# The timeout for a replacement.  By default, 15 seconds.
[timespan]
$ReplaceTimeout = '00:00:15',

# The name of the template.  This can be implied by the pattern.
[Alias('Name')]
$TemplateName,

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
$LinePattern,

[switch]
$AsScriptBlock,

# The Command Abstract Syntax Tree.  If this is provided, we are transpiling a template keyword.
[Parameter(ValueFromPipeline)]
[Management.Automation.Language.CommandAst]
$CommandAst
)

begin {
    $GetInlineScript = {
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

        if ($this.LinePattern) {$LinePattern = $this.LinePattern}

        if ($LinePattern -and $match.Groups["IsSingleLine"].Value) {
            $pipeScriptLines = @($pipeScriptText -split '(?>\r\n|\n)' -ne '')
            if ($pipeScriptLines.Length -gt 1) {
                $firstLine, $restOfLines = $pipeScriptLines
                $restOfLines = @($restOfLines)
                $pipeScriptText = @(@($firstLine) + $restOfLines -match $LinePattern -replace $LinePattern) -join [Environment]::Newline
            } else {
                $pipeScriptText = @($pipeScriptLines -match $LinePattern -replace $LinePattern) -join [Environment]::Newline
            }             
        }

        $InlineScriptBlock = [scriptblock]::Create($pipeScriptText)
        if (-not $InlineScriptBlock) {                    
            return
        }

        if ((-not $NoTranspile) -and 
            $ExecutionContext.SessionState.InvokeCommand.GetCommand('.>PipeScript','Alias')
        ) {
            $TranspiledOutput = $InlineScriptBlock | .>Pipescript
            if ($TranspiledOutput -is [ScriptBlock]) {
                $InlineScriptBlock = $TranspiledOutput
            }
        }
        $InlineScriptBlock
    }
}

process {
    #region Finding Template Transpiler 
    if ($CommandAst) {
        # Get command transpilers
        $LanguageCommands = @(Get-PipeScript -PipeScriptType Language)

        # Collect all of the bareword arguments
        $barewords = 
            @(foreach ($cmdElement in $CommandAst.CommandElements) {
                if (
                    $cmdElement -isnot [Management.Automation.Language.StringConstantExpressionAst] -or
                    $cmdElement.StringConstantType -ne 'Bareword'
                ) { break }
                $cmdElement.Value
            })
            
        
        # Find a matching template transpiler.
        $foundTemplateTranspiler = 
            :nextTranspiler foreach ($LanguageCommand in $LanguageCommands) {            
                $langName = $LanguageCommand.Name -replace 'Language\p{P}' -replace 'ps1$'
                                
                if (-not $langName) { continue }
                if ($barewords -contains $langName) {
                    $LanguageCommand
                    continue
                }
                if ($CommandAst.CommandElements[1] -is [Management.Automation.Language.MemberExpressionAst] -and 
                    $CommandAst.CommandElements[1].Member.Value -eq $langName) {
                    $LanguageCommand
                    continue
                }
                $attrList = 
                    if ($LanguageCommand.ScriptBlock.Attributes) {
                        $LanguageCommand.ScriptBlock.Attributes
                    }

                $languageCmd = $LanguageCommand                

                if (-not $ReplaceTimeout) {
                    $ReplaceTimeout = [timespan]"00:00:15"
                }

                $languageDefinition = & $languageCmd
                if ($languageDefinition.FilePattern) {
                    $regexPattern = [Regex]::new($languageDefinition.FilePattern, "IgnoreCase,IgnorePatternWhitespace", $ReplaceTimeout)
                    for ($barewordIndex = 0 ; $barewordIndex -lt 3; $barewordIndex++) {
                        if (-not $barewords[$barewordIndex]) { continue }
                        if ($regexPattern.Match($barewords[$barewordIndex]).Success) {
                            $templateName = $barewords[$barewordIndex]
                            $LanguageCmd
                            continue nextTranspiler
                        }
                        
                    }
                }
                
                foreach ($attr in $attrList) {
                    if ($attr -isnot [Management.Automation.ValidatePatternAttribute]) { continue }                    
                    
                    $regexPattern = [Regex]::new($attr.RegexPattern, $attr.Options, $ReplaceTimeout)
                    break
                    for ($barewordIndex = 0 ; $barewordIndex -lt 3; $barewordIndex++) {
                        if (-not $barewords[$barewordIndex]) { continue }
                        if ($regexPattern.Match($barewords[$barewordIndex]).Success) {
                            $templateName = $barewords[$barewordIndex]
                            $languageCmd
                            continue nextTranspiler
                        }                        
                    }
                    

                    if ($CommandAst.CommandElements[1] -is [Management.Automation.Language.MemberExpressionAst] -and 
                        $regexPattern.Match(('.' + $CommandAst.CommandElements[1].Member)).Success) {
                        $languageCmd
                        continue nextTranspiler
                    }                
                }
            }

        
        # If we found a template transpiler
        # we'll want to effectively pack the transpilation engine into an object
        if ($foundTemplateTranspiler) {
            if (-not $foundTemplateTranspiler.Parameters.AsTemplateObject -and -not ($foundTemplateTranspiler.pstypenames -contains 'Language.Command')) {
                Write-Error "$($foundTemplateTranspiler) does not support dynamic use"
                return
            }
            if ($foundTemplateTranspiler.pstypenames -contains 'Language.Command') {
                $languageDef = & $foundTemplateTranspiler
                foreach ($kv in $languageDef.psobject.properties) {
                    $ExecutionContext.SessionState.PSVariable.Set($kv.Name, $kv.Value)
                    $PSBoundParameters[$kv.Name] = $kv.Value
                }
            } else {
                $Splat = & $foundTemplateTranspiler -AsTemplateObject
                foreach ($kv in $splat.GetEnumerator()) {
                    $ExecutionContext.SessionState.PSVariable.Set($kv.Key, $kv.Value)
                    $PSBoundParameters[$kv.Key] = $kv.Value
                }
            }
        }
    }
    #endregion Finding Template Transpiler

    if ($barewords -contains 'function') {
        $AsScriptBlock = $true        
    }
    
    if ($StartPattern -and $EndPattern) {
        if (-not $ReplaceTimeout) {
            $ReplaceTimeout = [timespan]"00:00:15"
        }
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
        ", 'IgnoreCase, IgnorePatternWhitespace', $ReplaceTimeout)

        # Now switch the parameter set to SourceTextReplace
        $psParameterSet = 'SourceTextReplace'
    }

    $newModuleSplat = @{ScriptBlock={}}
    if ($SourceFile) {
        $newModuleSplat.Name = $SourceFile
    }

    # See if we have a replacement evaluator.
    if (-not $PSBoundParameters["ReplacementEvaluator"]) {
        # If we don't, create one.
        $ReplacementEvaluator = {
            param($match)
                        
            $InlineScriptBlock = 
                if ($this.GetInlineScript) {
                    $this.GetInlineScript($match)
                } else {
                    & $GetInlineScript $match
                }
            if (-not $InlineScriptBlock) { return }
            $inlineAstString = $InlineScriptBlock.Ast.Extent.ToString()
            if ($InlineScriptBlock.Ast.ParamBlock) {
                $inlineAstString = $inlineAstString.Replace($InlineScriptBlock.Ast.ParamBlock.Extent.ToString(), '')
            }
            $inlineAstString = $inlineAstString
            $ForeachObject = 
                if ("$($this.ForeachObject)" -notmatch "(?>^\s{0,}$|^\s{0,}\{\s{0,}\}\s{0,}$)") {
                    $this.ForeachObject
                } else { $ForeachObject }
            $begin = 
                if ($this.Begin) {
                    $this.Begin
                } else { $begin }
            $end =
                if ($this.End) {
                    $this.End
                } else { $end }

            $AddForeach =
                $(
                    if ($ForeachObject) {
                        '|' + [Environment]::NewLine
                        @(foreach ($foreachStatement in $ForeachObject) {
                            if ($foreachStatement.Ast.ProcessBlock -or $foreachStatement.Ast.BeginBlock) {
                                ". {$ForeachStatement}"
                            } elseif ($foreachStatement.Ast.EndBlock.Statements -and 
                                $foreachStatement.Ast.EndBlock.Statements[0].PipelineElements -and
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
            $context = 
                if ($this.Context) {
                    $this.Context
                } elseif ($FileModuleContext) {
                    $FileModuleContext
                }
            . $context { $match = $($args)} $match
            "$(. $context $codeToRun)"
        }
    }


    #region Template Keyword
    if ($CommandAst) {
        # This object will need to be able to evaluate itself.
        $EvaluateTemplate = {
            param()
            
            $fileText = $this.Template
            
            # Collect arguments for our template
            $ArgumentList = @()
            $Parameter = [Ordered]@{}
            foreach ($arg in $args) {
                if ($arg -is [Collections.IDictionary]) {
                    foreach ($kv in $arg.GetEnumerator()) {
                        $Parameter[$kv.Key] = $kv.Value
                    }
                } else {
                    $ArgumentList += $arg
                }
            }
            
            if (-not $ReplaceTimeout) {
                $ReplaceTimeout = [timespan]"00:00:15"
            }
            $ReplacePattern = [Regex]::new($this.Pattern,'IgnoreCase,IgnorePatternwhitespace',$ReplaceTimeout)
    
            # Walk thru each match before we replace it
            foreach ($match in $ReplacePattern.Matches($fileText)) {
                # get the inline script block
                $inlineScriptBlock = $this.GetInlineScript($match)
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
                . $this.Context $paramScriptBlock @Parameter @ArgumentList
            }
            $ReplacementEvaluator = 
                if ($this.Evaluator.Script) {
                    $this.Evaluator.Script
                } elseif ($ReplacementEvaluator) {
                    $ReplacementEvaluator
                } else {
                    {}
                }
            return $ReplacePattern.Replace($fileText, $ReplacementEvaluator)
        }

        $templateToString = {
            param()

            if ($args) {
                $this.Evaluate($args)
            }
            else {
                $this.Evaluate()
            }
        }

        $SaveTemplate = {
            param()

            if ($this.Name -eq $this.Language) {
                $name, $evalArgs = $args
            } else {
                if ($args -and $args[0] -is [string] -and $args[0] -match '[\\/\.]') {
                    $name, $evalArgs = $args
                } else {
                    $name = $this.Name
                    $evalArgs = $args
                }
            }

            if (-not $name) {
                throw "Must provide a .Name or the first argument must be a name"
            }

            $evaluated = 
                if ($evalArgs) {
                    $this.Evaluate($evalArgs)    
                } else {
                    $this.Evaluate()
                }
            
            if (-not (Test-Path $Name)) {
                $null = New-Item -ItemType File -Path $name -Force
            }            
            $evaluated | Set-Content -Path $name
            Get-Item -Path $name        
        }
        $filePattern = 
            foreach ($attr in $foundTemplateTranspiler.ScriptBlock.Attributes) {
                if ($attr -is [ValidatePattern]) {
                    $attr.RegexPattern
                    break
                }
            }
        $mySentence = $CommandAst.AsSentence($MyInvocation.MyCommand)
        if ($mySentence.Parameter.Count) {
            foreach ($clause in $mySentence.Clauses) {
                if ($clause.ParameterName) {
                    $ExecutionContext.SessionState.PSVariable.Set($clause.ParameterName, $mySentence.Parameter[$clause.Name])
                }
            }            
        }
        $null, $templateElements = foreach ($sentenceArg in $mySentence.ArgumentList) {
            if ($sentenceArg.StringConstantType -eq 'Bareword' -and $sentenceArg.Value -in 'template', 'function') {
                continue
            }
            if ($sentenceArg -in 'template', 'function') { continue }
            $convertedAst = 
                if ($sentenceArg.ConvertFromAst) {
                    $sentenceArg.ConvertFromAst()
                } else {
                    $sentenceArg
                }
            
            if ($convertedAst -is [string]) {
                $convertedAst = "'$($convertedAst -replace "'","''")'"
            }
            if ($convertedAst -is [ScriptBlock]) {
                $convertedAst = "{$ConvertedAst}"
            }
            $convertedAst
        }
        if (-not $templateElements) { $templateElements = "''"}        
        $languageString = $(
            if ($foundTemplateTranspiler.pstypenames -contains 'Language.Command') {
                $foundTemplateTranspiler.Name -replace 'Language\p{P}' -replace 'ps1$'                
            } else {
                $foundTemplateTranspiler.DisplayName -replace '(?>Template|Inline)\.' -replace '^\.'
            }            
        )
        if (-not $TemplateName) { $TemplateName = $languageString }
        $createdSb = [scriptblock]::Create(@"
`$(
`$templateObject = [PSCustomObject][Ordered]@{
    PSTypeName = 'PipeScript.Template'
    Name = '$($TemplateName -replace "'", "''")'
    Language = '$languageString'
    $(if ($LinePattern) {
        "LinePattern = '$LinePattern'"
    })
    SourceFile = ''
    FilePattern = '$($filePattern -replace "'", "''")'
    Pattern = 
       [regex]::new(@'
$replacePattern
'@,'IgnoreCase,IgnorePatternWhitespace', '00:00:05')
    Context = New-Module -ScriptBlock {}
    ForeachObject = $(if ($ForeachObject) { "{ 
        $foreachObject
    }"} else {'{}'})
    Begin = $(if ($Begin) { "{ 
        $begin
    }"} else {'{}'})
    End = $(if ($End) { "{ 
        $end
    }"} else {'{}'})
    Template = $templateElements
}
`$templateObject.psobject.members.Add([PSScriptMethod]::new(
    'Evaluator', {
        $replacementEvaluator
    }
), `$true)
`$templateObject.psobject.members.Add([PSScriptMethod]::new(
    'Evaluate', {
        $evaluateTemplate
    }
), `$true)
`$templateObject.psobject.members.Add([PSScriptMethod]::new(
    'GetInlineScript', {
        $GetInlineScript
    }
), `$true)
`$templateObject.psobject.members.Add([PSScriptMethod]::new(
    'EvaluateTemplate', {
        $EvaluateTemplate
    }
), `$true)
`$templateObject.psobject.members.Add([PSScriptMethod]::new(
    'Save', {
        $SaveTemplate
    }
), `$true)
`$templateObject.psobject.members.Add([PSScriptMethod]::new(
    'ToString', {
        $TemplateToString
    }
), `$true)
`$templateObject
)
"@
)
        if (-not ($mySentence.ArgumentList -contains 'function')) {
            $createdSb        
            return        
        }       
    }
    #endregion Template Keyword

    $FileModuleContext = New-Module @newModuleSplat


    # There are a couple of paths we could take from here:
    # We could replace inline, and keep a context for variables
    # Or we can turn the whole thing into a `[ScriptBlock]`
    if ($AsScriptBlock) {
        $index = 0
        $fileText      = $SourceText        
        if ((-not $fileText) -and $CommandAst) {
            $firstElement, $templateContent = $CommandAst.CommandElements -notmatch '^(?>template|function)$'
            $OptimizedTemplateElement = $null
            $fileText  = @(foreach ($contentElement in $templateContent) {
                if ($contentElement -is [Management.Automation.Language.StringConstantExpressionAst]) {
                    $contentElement.Value
                }
                elseif ($contentElement -is [Management.Automation.Language.ExpandableStringExpressionAst]) {
                    $OptimizedTemplateElement = $contentElement
                }
                elseif ($contentElement -is [Management.Automation.Language.ScriptBlockExpressionAst]) {
                    $OptimizedTemplateElement = $contentElement
                }
            }) -join ' '            
        }

        if ($OptimizedTemplateElement) {
            $templateScriptBlock = @(foreach ($optimizedElement in $OptimizedTemplateElement) {
                if ($OptimizedTemplateElement -is [Management.Automation.Language.ExpandableStringExpressionAst]) {
                    New-PipeScript -AutoParameter -Process ([scriptblock]::Create($OptimizedTemplateElements))
                }
                elseif ($optimizedElement -is [Management.Automation.Language.ScriptBlockExpressionAst]) {                    
                    $optimizedElement.AsScriptBlock()
                }
            }) | Join-PipeScript
            
            $templatePreCompiledString = @("template function $TemplateName {", $templateScriptBlock,"}") -join [Environment]::newLine             
            [ScriptBlock]::Create("$templatePreCompiledString") | Use-PipeScript
            return
        }

        if (-not $fileText) { return }

        $hasParameters = $false
        $allInlineScripts = @()
        
        $newContent = @(
        foreach ($match in $ReplacePattern.Matches($fileText)) {
            if ($match.Index -gt $index) {
                "@'" + 
                    [Environment]::NewLine + 
                    (
                        $fileText.Substring($index, $match.Index - $index) -replace "'@", "''@"  -replace "@'", "@''" 
                    ) +
                    [Environment]::NewLine +
                "'@" + { -replace "''@", "'@" -replace "@''", "'@"} + [Environment]::NewLine 
            }
            $inlineScriptBlock = & $GetInlineScript $match
            if (-not $inlineScriptBlock) { 
                continue # skip.
            }

            $allInlineScripts += $inlineScriptBlock

            $inlineScriptBlock = if ($inlineScriptBlock.Ast.ParamBlock) {                
                $hasParameters = $true
                "$inlineScriptBlock".Substring($inlineScriptBlock.Ast.ParamBlock.Extent.ToString().Length)
            } else {
                "$inlineScriptBlock"
            }

            if ($Begin) {
                "$Begin"
            }

            if ($ForeachObject) {
                "@($inlineScriptBlock)" + $(
                    if ($ForeachObject) {
                        '|' + [Environment]::NewLine
                        @(foreach ($foreachStatement in $ForeachObject) {
                            if ($foreachStatement.Ast.ProcessBlock -or $foreachStatement.Ast.BeginBlock) {
                                ". {$ForeachStatement}"
                            } elseif ($foreachStatement.Ast.EndBlock.Statements -and 
                                $foreachStatement.Ast.EndBlock.Statements[0].PipelineElements -and
                                $foreachStatement.Ast.EndBlock.Statements[0].PipelineElements[0].CommandElements -and
                                $foreachStatement.Ast.EndBlock.Statements[0].PipelineElements[0].CommandElements.Value -in 'Foreach-Object', '%') {
                                "$ForeachStatement"
                            } else {
                                "Foreach-Object {$ForeachStatement}"
                            }
                        }) -join (' |' + [Environment]::NewLine)
                    }
                )
            } else {
                $inlineScriptBlock
            }

            if ($end) {
                "$end"
            }
                    
            $index = $match.Index + $match.Length            
        }
        if ($index -lt $fileText.Length) {
            "@'" + [Environment]::NewLine + (
                $fileText.Substring($index) -replace "'@", "''@"
            )  + [Environment]::NewLine + 
            "'@" + 
            { -replace "''@", "'@" -replace "@''", "'@"} + 
            [Environment]::NewLine            
        }
        )

        $templateScriptBlock = 
            if ($hasParameters) {
                $combinedParamBlock = $allInlineScripts | Join-ScriptBlock -IncludeBlockType param, header, help
                
                $combinedParamBlock, ([ScriptBlock]::Create($newContent -join [Environment]::NewLine)) | Join-PipeScript
            } else {
                ([ScriptBlock]::Create($newContent -join [Environment]::NewLine))
            }

        if ($templateScriptBlock -and $barewords -contains "function") {
            $templatePreCompiledString = @("template function $TemplateName {", $templateScriptBlock,"}") -join [Environment]::newLine             
            [ScriptBlock]::Create("$templatePreCompiledString") | Use-PipeScript
            return
        }

        $null = $null
        
    }

    # If the parameter set was SourceTextReplace
    if ($ReplacePattern) {
        $fileText      = $SourceText
        

        # Walk thru each match before we replace it
        foreach ($match in $ReplacePattern.Matches($fileText)) {
            # get the inline script block
            $inlineScriptBlock = & $GetInlineScript $match
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
        $replacement = 
            try {
                $ReplacePattern.Replace($fileText, $ReplacementEvaluator)
            } catch {
                $ex = $_
                Write-Error -ErrorRecord $ex
                # $PSCmdlet.WriteError($ex)
            }
        return $replacement
    }
}

