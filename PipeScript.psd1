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
    FunctionsToExport = 'Get-Transpiler','Start-PSNode','PipeScript.Optimizer.ConsolidateAspects','Route.Uptime','Route.VersionInfo','Export-Pipescript','Get-PipeScript','Import-PipeScript','Invoke-PipeScript','Join-PipeScript','New-PipeScript','Search-PipeScript','Update-PipeScript','Use-PipeScript','Import-ModuleMember','Export-Json','Import-Json','ConvertFrom-CliXml','ConvertTo-CliXml','Get-Interpreter','Invoke-Interpreter','Out-Parser','Parse.CSharp','Parse.PowerShell','Protocol.HTTP','Protocol.JSONSchema','Protocol.OpenAPI','Protocol.UDP','Aspect.DynamicParameter','Aspect.ModuleExtensionType','Aspect.ModuleExtensionPattern','Aspect.ModuleExtensionCommand','Aspect.GroupObjectByTypeName','Aspect.GroupObjectByType','Signal.Nothing','Signal.Out','PipeScript.PostProcess.InitializeAutomaticVariables','PipeScript.PostProcess.PartialFunction','Out-HTML','PipeScript.Automatic.Variable.IsPipedTo','PipeScript.Automatic.Variable.IsPipedFrom','PipeScript.Automatic.Variable.MyCallstack','PipeScript.Automatic.Variable.MySelf','PipeScript.Automatic.Variable.MyParameters','PipeScript.Automatic.Variable.MyCaller','PipeScript.Automatic.Variable.MyCommandAst','Compile.LanguageDefinition','Language.JavaScript','Template.Assignment.js','Template.Class.js','Template.DoLoop.js','Template.ForEachLoop.js','Template.ForLoop.js','Template.Function.js','Template.HelloWorld.js','Template.InvokeMethod.js','Template.RegexLiteral.js','Template.TryCatch.js','Template.WhileLoop.js','Language.Rust','Language.Lua','Language.FSharp','Language.GCode','Language.XSD','Language.Ruby','Template.HelloWorld.rb','Language.Haxe','Language.Scala','Language.Racket','Language.SQL','Language.Arduino','Language.PipeScript','Language.Java','Language.Kotlin','Language.Bicep','Language.Markdown','Language.Go','Template.HelloWorld.go','Language.C3','Language.XSL','Language.GLSL','Language.JSON','Language.Batch','Language.TypeScript','Template.HelloWorld.ts','Language.BASIC','Language.XML','Language.CSS','Language.Vue','Language.YAML','Language.TCL','Language.SVG','Language.Docker','Template.Docker.Add','Template.Docker.Argument','Template.Docker.Command','Template.Docker.CopyItem','Template.Docker.EntryPoint','Template.Docker.SetVariable','Language.CSharp','Template.Class.cs','Template.HelloWorld.cs','Template.Method.cs','Template.Namespace.cs','Template.Property.cs','Template.TryCatch.cs','Language.PowerShell','Language.PowerShellData','Language.PowerShellXML','Language.Conf','Language.Bash','Language.HCL','Language.Razor','Language.OpenSCAD','Language.RSS','Language.ADA','Language.XAML','Language.R','Language.Dart','Language.Crystal','Template.HelloWorld.cr','Language.Perl','Language.BrightScript','Language.Wren','Template.HelloWorld.wren','Language.CPlusPlus','Template.HelloWorld.cpp','Template.Include.cpp','Language.Liquid','Language.Eiffel','Language.Python','Template.Assignment.py','Template.DoLoop.py','Template.HelloWorld.py','Template.Import.py','Template.UntilLoop.py','Template.WhileLoop.py','Language.WebAssembly','Language.HLSL','Language.PHP','Language.Kusto','Language.C','Template.Include.c','Language.TOML','Language.HTML','Language.LaTeX','Language.ATOM','Language.ObjectiveC'
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

        Videos = @{
            "Run Anything with PipeScript (from RTPSUG)" = "https://www.youtube.com/watch?v=-PuiNAcvalw"
        }

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
* Get-Interpreter (#747)
* New Languages Supported:
  * Crystal (#878)
  * C3 (#870)
* Export-PipeScript Improvements:
  * Conditional Build Support (#907)
  * GitHub Build Summary Support (#914)
* More Language Support:
  * More Hello Worlds (#846)
    * Template.HelloWorld.go
    * Template.HelloWorld.py
    * Template.HelloWorld.cpp
    * Template.HelloWorld.cr
  * Python Improvements:
    * Python Keywords map (#872)
    * Template.Assignment.py (#927)
    * Template.DoLoop.py (#929)
    * Template.Import.py (#913)
    * Template.UntilLoop.py (#939)
    * Template.WhileLoop.py (#936)
* New ScriptProperties
  * Language.HasPowerShellInterpreter (#904)
  * Language.HasInterpreter (#903)
  * Language.Alias(es) (#)
* Adding .Parallel option to GitHub action (defaulting to Serial) (#888)
* Fixing Alias for Aliases Compiler (thanks @HCRitter ! )

---
            
Additional history in [CHANGELOG](https://github.com/StartAutomating/PipeScript/blob/main/CHANGELOG.md)

Like it?  Star It!  Love it?  Support It!

'@
        }
    }
}

