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
    FunctionsToExport = 'Language.Dart','Template.HelloWorld.dart','Language.Batch','Language.CSharp','Template.Class.cs','Template.HelloWorld.cs','Template.Method.cs','Template.Namespace.cs','Template.Property.cs','Template.TryCatch.cs','Language.Go','Template.HelloWorld.go','Language.Ruby','Template.HelloWorld.rb','Language.Razor','Language.Bash','Language.Conf','Language.Docker','Template.Docker.InstallModule','Template.Docker.InstallPackage','Template.Docker.LabelModule','Template.Docker.Add','Template.Docker.Argument','Template.Docker.Command','Template.Docker.CopyItem','Template.Docker.EntryPoint','Template.Docker.Expose','Template.Docker.From','Template.Docker.HealthCheck','Template.Docker.Label','Template.Docker.OnBuild','Template.Docker.Run','Template.Docker.SetLocation','Template.Docker.SetShell','Template.Docker.SetUser','Template.Docker.SetVariable','Template.Docker.StopSignal','Template.Docker.Volume','Language.ATOM','Language.JavaScript','Template.Assignment.js','Template.Class.js','Template.DoLoop.js','Template.ForEachLoop.js','Template.ForLoop.js','Template.Function.js','Template.HelloWorld.js','Template.InvokeMethod.js','Template.RegexLiteral.js','Template.TryCatch.js','Template.WhileLoop.js','Language.Perl','Language.Bicep','Language.LaTeX','Language.XAML','Language.XML','Language.YAML','Language.HLSL','Language.CPlusPlus','Template.HelloWorld.cpp','Template.Include.cpp','Language.Kotlin','Language.JSON','Language.TCL','Language.HTML','Language.CSS','Language.SVG','Language.Racket','Language.OpenSCAD','Language.Rust','Language.PowerShell','Language.PowerShellData','Language.PowerShellXML','Language.FSharp','Language.R','Language.Liquid','Language.Lua','Language.TypeScript','Template.HelloWorld.ts','Language.BrightScript','Language.C','Template.Include.c','Language.Haxe','Language.Vue','Language.Eiffel','Language.RSS','Language.GLSL','Language.XSL','Language.Python','Template.Assignment.py','Template.DoLoop.py','Template.HelloWorld.py','Template.Import.py','Template.UntilLoop.py','Template.WhileLoop.py','Language.SQL','Language.Arduino','Language.GCode','Language.TOML','Language.Java','Language.XSD','Language.PipeScript','Language.Scala','Language.Markdown','Language.Crystal','Template.HelloWorld.cr','Language.HCL','Language.ADA','Language.C3','Language.WebAssembly','Language.Kusto','Language.ObjectiveC','Language.BASIC','Language.PHP','Language.Wren','Template.HelloWorld.wren','Get-Transpiler','Start-PSNode','PipeScript.PostProcess.InitializeAutomaticVariables','PipeScript.PostProcess.PartialFunction','ConvertFrom-CliXml','ConvertTo-CliXml','Export-Json','Import-Json','Out-HTML','Get-Interpreter','Invoke-Interpreter','Out-Parser','Parse.CSharp','Parse.PowerShell','PipeScript.Optimizer.ConsolidateAspects','Signal.Nothing','Signal.Out','Aspect.DynamicParameter','Aspect.ModuleExtensionType','Aspect.ModuleExtensionPattern','Aspect.ModuleExtensionCommand','Aspect.GroupObjectByTypeName','Aspect.GroupObjectByType','Import-ModuleMember','Compile.LanguageDefinition','Export-Pipescript','Get-PipeScript','Import-PipeScript','Invoke-PipeScript','Join-PipeScript','New-PipeScript','Search-PipeScript','Update-PipeScript','Use-PipeScript','PipeScript.Automatic.Variable.IsPipedTo','PipeScript.Automatic.Variable.IsPipedFrom','PipeScript.Automatic.Variable.MyCallstack','PipeScript.Automatic.Variable.MySelf','PipeScript.Automatic.Variable.MyParameters','PipeScript.Automatic.Variable.MyCaller','PipeScript.Automatic.Variable.MyCommandAst','Protocol.HTTP','Protocol.JSONSchema','Protocol.OpenAPI','Protocol.UDP','Route.Uptime','Route.VersionInfo'
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

            'ContentType' = @{
                Description = 'A content type command.'
                Pattern = '
                    (?<=(?>$|\p{P}))
                    (?>
                        application|
                        audio|
                        video|
                        image|
                        message|
                        multipart|
                        text|
                        model|
                        example|
                        font
                    )
                    (?=(?>\p{P}))
                '
                ExcludeCommandType = '(?>Application|Script|Cmdlet)'
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

