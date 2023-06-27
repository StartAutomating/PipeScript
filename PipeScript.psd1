@{
    ModuleVersion     = '0.2.5'
    Description       = 'An Extensible Transpiler for PowerShell (and anything else)'
    RootModule        = 'PipeScript.psm1'
    PowerShellVersion = '4.0'
    AliasesToExport   = '*'
    FormatsToProcess  = 'PipeScript.format.ps1xml'
    TypesToProcess    = 'PipeScript.types.ps1xml'
    Guid              = 'fc054786-b1ce-4ed8-a90f-7cc9c27edb06'
    CompanyName       = 'Start-Automating'
    Copyright         = '2022 Start-Automating'
    Author            = 'James Brundage'
    FunctionsToExport = 'Export-Pipescript','Get-PipeScript','Get-Transpiler','Import-PipeScript','Invoke-PipeScript','Join-PipeScript','New-PipeScript','Search-PipeScript','Update-PipeScript','Use-PipeScript','PipeScript.Automatic.Variable.IsPipedTo','PipeScript.Automatic.Variable.IsPipedFrom','PipeScript.Automatic.Variable.MyCallstack','PipeScript.Automatic.Variable.MySelf','PipeScript.Automatic.Variable.MyParameters','PipeScript.Automatic.Variable.MyCaller','PipeScript.Automatic.Variable.MyCommandAst','PipeScript.Optimizer.ConsolidateAspects','Protocol.HTTP','Protocol.JSONSchema','Protocol.OpenAPI','Protocol.UDP','Aspect.DynamicParameter','Aspect.ModuleExtensionType','Aspect.ModuleExtensionPattern','Aspect.ModuleExtensionCommand','PipeScript.PostProcess.InitializeAutomaticVariables','PipeScript.PostProcess.PartialFunction'
    PrivateData = @{
        FunctionTypes = @{
            'Partial' = @{
                Description = 'A partial function.'
                Pattern = '(?>PipeScript\p{P})?Partial\p{P}'
            }

            'PreProcessor' = @{
                Description = 'Preprocessing Commands'
                Pattern     = '
                    (?>PipeScript\p{P})?  # (optionally) PipeScript+Punctuation
                    PreProc[^\p{P}]+\p{P} # Preproc + Many NotPunctuation + Punctuation
                '
            }

            'PostProcessor' = @{
                Description = 'PostProcessing Commands'
                Pattern     = '
                    (?>PipeScript\p{P})?  # (optionally) PipeScript+Punctuation
                    PostProc[^\p{P}]+\p{P} # Postproc + Many NotPunctuation + Punctuation
                '
            }

            'Optimizer' = @{
                Description = 'Optimization Commands'
                Pattern     = '
                    (?>PipeScript\p{P})?  # (optionally) PipeScript+Punctuation
                    Optimiz[^\p{P}]+\p{P} # Optimiz + Many NotPunctuation + Punctuation
                '
            }

            'Protocol'   = @{
                Description = 'Protocol Commands'
                Pattern = '
                    (?>PipeScript\p{P})?         # Optional PipeScript + Punctuation
                    (?>Protocol\p{P})            # Protocol + Punctuation
                    (?=[^\p{P}]+$)               # Followed by anything but punctuation.
                '
            }

            'PipeScriptNoun' = @{
                Description = 'Commands with the noun PipeScript'
                Pattern = '[^\-]+\-PipeScript$'
            }
        }
        ScriptTypes = @{
            'BuildScript'    = @{
                Description = 'A file that will be run at build time.'
                Pattern = '(?<=(?>^|\.))build\.ps1$'
            }
        }
        CommandTypes = @{
            'Aspect' = @{
                Description = 'An aspect of code.'
                Pattern = '                    
                    (?>PipeScript\p{P})? # (optionally) PipeScript+Punctuation
                    Aspect\p{P}          # Followed by Aspect and punctuation.
                '
                ExcludeCommandType = '(?>Application|Script|Cmdlet)'
            }
            'Analyzer' = @{
                Description = 'Analyzation Commands'
                Pattern     = '
                    (?>PipeScript\p{P})?   # (optionally) PipeScript+Punctuation
                    Analy[zs][^\p{P}]+\p{P} # Anal[zs] + Many NotPunctuation + Punctuation
                '
            }

            'AutomaticVariable' = @{
                Description = 'An automatic variable.'
                Pattern = '
                    (?>PipeScript\p{P})? # (optionally) PipeScript+Punctuation
                    (?>Automatic|Magic)  # automatic or magic
                    \p{P}?Variable\p{P}  # Optional Punctation + Variable + Punctuation
                    (?=[^\p{P}]+$)       # Followed by anything but punctuation.
                '
                CommandType = '(?>Function|Alias)'
            }
                                    
            'Interface'  = @{
                Description = 'An Interface Command'
                Pattern = '(?>PipeScript\p{P})?Interface\p{P}'
            }
                
            'Sentence'   = @{
                Description = 'Sentence Commands'
                Pattern = '(?>PipeScript\p{P})?Sentence\p{P}'
            }              
                            
            'Transpiler' = 
                @{
                    Description = 'Transpiles an object into anything.'
                    Pattern = '
                        (?>
                            (?:\.psx\.ps1$) # A .PSX.PS1 Script
                                |
                            (?<![\-_]) # not after dash or underscore
                            (?:PipeScript\p{P})?(?>Transpiler|PSX)
                            (?!.+?\.ps1$) 
                        )
                    '
                }
              
            'Template'     = 
                @{
                    Description = 'Templates let you write other languages with PipeScript.'
                    Pattern = '\.ps1{0,1}\.(?<ext>[^\.]+$)'
                }                        
        }
        PSData = @{
            ProjectURI = 'https://github.com/StartAutomating/PipeScript'
            LicenseURI = 'https://github.com/StartAutomating/PipeScript/blob/main/LICENSE'
            RecommendModule = @('PSMinifier')
            RelatedModule   = @()
            BuildModule     = @('EZOut','Piecemeal','PipeScript','HelpOut', 'PSDevOps')
            Tags            = 'PipeScript','PowerShell', 'Transpilation', 'Compiler'
            ReleaseNotes = @'
## PipeScript 0.2.5:

* Added Support for Aspects (#401)
* Support for Pre/Post commands in Core Transpiler
  * Commands Named PipeScript.PreProcess / PipeScript.Analyzer will run before transpilation of a ScriptBlock 
  * Commands Named PipeScript.PostProcess / PipeScript.Optimizer will run after transpilation of a ScriptBlock
* Adding PipeScript.Optimizer.ConsolidateAspects (Fixes #413)
* Conditional Keywords Fixes (Fixes #402)
* New-PipeScript: Improving Pipelining (Fixes #400)
* Update-PipeScript:
  * Tracing Events (#407)
  * Support for Insertions (#405, #406, #407)
* Template Improvements
  * Templates can now be either singleline or multiline (Fixes #398)
* New Language Support
  * Eiffel (#404)
  * PS1XML (#414)
  * SVG (#411)
  * XAML (#414)  
* XML Transpilers support inline xml output (Fixes #412)
* Added initial demo file (Fixes #420)

---
            
Additional history in [CHANGELOG](https://pipescript.start-automating.com/CHANGELOG)
'@
        }
    }
}

