@{
    ModuleVersion     = '0.2.8'
    Description       = 'Metaprogram PowerShell (and everything else)'
    RootModule        = 'PipeScript.psm1'
    PowerShellVersion = '4.0'
    AliasesToExport   = '*'
    FormatsToProcess  = 'PipeScript.format.ps1xml'
    TypesToProcess    = 'PipeScript.types.ps1xml'
    Guid              = 'fc054786-b1ce-4ed8-a90f-7cc9c27edb06'
    CompanyName       = 'Start-Automating'
    Copyright         = '2022-2023 Start-Automating'
    Author            = 'James Brundage'
    FunctionsToExport = '*' <#{
        $exportNames = Get-ChildItem -Recurse -Filter '*-*.ps1' |
            Where-Object Name -notmatch '\.ps1?\.ps1$' |            
            Foreach-Object {
              foreach ($match in @(
                  [Regex]::Matches((Get-Content -Raw $_.FullName), "^function\s(?<n>[\S-[\(\)]]+)\s{0,}\{", 'Multiline')
              )) {
                if ($match.Groups["n"] -match '\p{P}') {
                  $match.Groups["n"]
                }
              }              
            }
        "'$($exportNames -join "','")'"
    }#>
    PrivateData = @{        
        FunctionTypes = @{
            'Partial' = @{
                Description = 'A partial function.'
                Pattern = '(?>PipeScript\p{P})?Partial\p{P}'
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

            'Language' = @{
                Description = 'Language Commands describe languages'
                Pattern = '                    
                    Language    # Language
                    (?>
                        \.ps1$  # ending with .ps1
                        |       # or
                        \p{P}   # followed by punctuation
                    )
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

            'Compiler' = @{
                Description = 'A Compiler'
                Pattern = '
                    (?>                        
                        \.psx.ps1$|
                        Compiler\.ps1$|
                        \.psc.ps1$|
                        Compile[sr]?\p{P}
                    )
                '
                ExcludeCommandType = 'Application'
            }

            'PreProcessor' = @{
                Description = 'Preprocessing Commands'
                Pattern     = '
                    (?>PipeScript\p{P})?  # (optionally) PipeScript+Punctuation
                    PreProc[^\p{P}]+\p{P} # Preproc + Many NotPunctuation + Punctuation
                '
                ExcludeCommandType = '(?>Application|Script|Cmdlet)'
            }

            'PostProcessor' = @{
                Description = 'PostProcessing Commands'
                Pattern     = '
                    (?>PipeScript\p{P})?  # (optionally) PipeScript+Punctuation
                    PostProc[^\p{P}]+\p{P} # Postproc + Many NotPunctuation + Punctuation
                '
                ExcludeCommandType = '(?>Application|Script|Cmdlet)'
            }
            
            'Parser' = @{
                Description = 'Parsers'
                Pattern = '
                    (?>^|\.)                # After a period or the start of a string
                    Parse[sr]?              # Parse or Parses or Parser + Punctuation
                    (?>
                        \.ps1$                     # Ending with .ps1
                        |                          # or
                        \p{P}
                    )
                '
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

            'Transform' = @{
                Description = 'Transforms'
                Pattern = '              
                    (?>
                        # Transforms have two forms, one that is more "query" friendly
                        (?:
                            \=\>? # =>?
                            (?<TransformStep>
                                (?:.|\s){0,}?(?=\z|\=\>?)
                            )
                        ){1,}
                        |
                        # The other form is fairly normal:
                        Transform(?>s|er)?             # Transform or Transforms or Transformer
                        (?>
                            \.ps1$                     # ending with .ps1
                            |                          # or
                            \p{P}                      # followed by punctuation
                        )
                    )
                '
                ExcludeCommandType = '(?>Application|Script|Cmdlet)'
            }
            
            'Route' = @{
                Pattern = '
                    (?>^|\.)                # After a period or the start of a string
                    Route[sr]?              # The words Route or Routes or Router
                    (?>                     # Followed by either
                        \.ps1$              # the .ps1 and end of string
                        |                   # or 
                        \p{P}               # any other punctuation.
                    )
                '
                ExcludeCommandType = '(?>Application|Cmdlet)'
            }
              
            'Template'     = 
                @{
                    Description = 'Templates let you write other languages with PipeScript.'
                    Pattern = '\.ps1{0,1}\.(?<ext>[^\.]+$)'
                }                        
        }

        Server = 'pipescript.dev', 'pipescript.info', 'pipescript.io'
        Servers = 'pipescript.startautomating.com','pipescript.start-automating.com'

        PSData = @{
            ProjectURI = 'https://github.com/StartAutomating/PipeScript'
            LicenseURI = 'https://github.com/StartAutomating/PipeScript/blob/main/LICENSE'
            RecommendModule = @('PSMinifier')
            RelatedModule   = @()
            BuildModule     = @('EZOut','Piecemeal','PipeScript','HelpOut', 'PSDevOps')
            Tags            = 'PipeScript','PowerShell', 'Transpilation', 'Compiler'
            ReleaseNotes = @'
## PipeScript 0.2.8:

More Implicit Interpretation!

* Invoke-Interpreter will now JSONify non-string arguments (#896)
* Invoke-Interpreter will now call Out-Parser (#857, #858)
* Improved Interpreter exclusions
    * `.ExcludePath` excludes path wildcards (#875, #877)
    * `.ExcludePattern` excludes by pattern (#875, #876)
* Implicit Interpretation Demo (#886)
* New Languages Supported:
    * Crystal (#878)
* More Language Support
    * Template.HelloWorld.go (#846)
    * Template.HelloWorld.py (#846)
    * Python Keywords map (#872)
* New ScriptProperties
    * Language.HasPowerShellInterpreter (#904)
    * Language.HasInterpreter (#903)
* Adding .Parallel option to GitHub action (defaulting to Serial) (#888)
* Fixing Aliases for Aliases (thanks @HCRitter ! )

---
            
Additional history in [CHANGELOG](https://github.com/StartAutomating/PipeScript/blob/main/CHANGELOG.md)

Like it?  Star It!  Love it?  Support It!

'@
        }
    }
}
