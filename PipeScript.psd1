@{
    ModuleVersion     = '0.2.7'
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
    FunctionsToExport = 'Language.CSharp','Template.Class.cs','Template.HelloWorld.cs','Template.Method.cs','Template.Namespace.cs','Template.Property.cs','Template.TryCatch.cs','Language.JSON','Language.Ruby','Template.HelloWorld.rb','Language.XAML','Language.Wren','Template.HelloWorld.wren','Language.TCL','Language.Bash','Language.XSD','Language.Java','Language.Docker','Language.Kusto','Language.Python','Template.HelloWorld.py','Language.JavaScript','Template.Assignment.js','Template.Class.js','Template.DoLoop.js','Template.ForEachLoop.js','Template.ForLoop.js','Template.Function.js','Template.HelloWorld.js','Template.InvokeMethod.js','Template.RegexLiteral.js','Template.TryCatch.js','Template.WhileLoop.js','Language.Crystal','Template.HelloWorld.cr','Language.ADA','Language.Bicep','Language.Perl','Language.PipeScript','Language.ATOM','Language.Haxe','Language.BASIC','Language.XML','Language.PHP','Language.GLSL','Language.Kotlin','Language.XSL','Language.FSharp','Language.Batch','Language.Arduino','Language.ObjectiveC','Language.HLSL','Language.OpenSCAD','Language.CSS','Language.HTML','Language.TOML','Language.Liquid','Language.HCL','Language.CPlusPlus','Language.GCode','Language.SVG','Language.Conf','Language.Go','Template.HelloWorld.go','Language.Eiffel','Language.YAML','Language.Razor','Language.TypeScript','Template.HelloWorld.ts','Language.Dart','Language.Markdown','Language.BrightScript','Language.Scala','Language.Vue','Language.WebAssembly','Language.SQL','Language.RSS','Language.Rust','Language.Racket','Language.LaTeX','Language.R','Language.PowerShell','Language.PowerShellData','Language.PowerShellXML','Language.Lua','Get-Transpiler','Start-PSNode','Export-Json','Import-Json','Aspect.DynamicParameter','Aspect.ModuleExtensionType','Aspect.ModuleExtensionPattern','Aspect.ModuleExtensionCommand','Aspect.GroupObjectByTypeName','Aspect.GroupObjectByType','Export-Pipescript','Get-PipeScript','Import-PipeScript','Invoke-PipeScript','Join-PipeScript','New-PipeScript','Search-PipeScript','Update-PipeScript','Use-PipeScript','Compile.LanguageDefinition','Out-HTML','Route.Uptime','Route.VersionInfo','Signal.Nothing','Signal.Out','Invoke-Interpreter','ConvertFrom-CliXml','ConvertTo-CliXml','Import-ModuleMember','Protocol.HTTP','Protocol.JSONSchema','Protocol.OpenAPI','Protocol.UDP','Parse.CSharp','Parse.PowerShell','PipeScript.PostProcess.InitializeAutomaticVariables','PipeScript.PostProcess.PartialFunction','PipeScript.Optimizer.ConsolidateAspects','PipeScript.Automatic.Variable.IsPipedTo','PipeScript.Automatic.Variable.IsPipedFrom','PipeScript.Automatic.Variable.MyCallstack','PipeScript.Automatic.Variable.MySelf','PipeScript.Automatic.Variable.MyParameters','PipeScript.Automatic.Variable.MyCaller','PipeScript.Automatic.Variable.MyCommandAst'
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
## PipeScript 0.2.7:

PipeScript can now easily define any language and you can now interpret Anything with PipeScript!

* Complete Overhaul of Languages in PipeScript!
  * Languages are now defined in open-ended psuedo-object
  * They can define an .Interpreter
  * If they do, the language can be dynamically interpreted!
  * Languages can also specify translation methods (.TranslateFromAstType)
  * More support for the PowerShell Abstract Syntax Tree and Roslyn
  * New languages supported: Docker, XSL, XSD, BrightScript, Conf, Wren, Vue, F#, GCODE
* New Commands:
  * Start-PSNode lets you run PowerShell as a microservice
  * Import/Export-JSON make JSON easier to work with
  * Import-ModuleMember lets modules flexibly self-extend
  * Out-HTML gives formatted HTML output!

... and much, much more

---
            
Additional history in [CHANGELOG](https://github.com/StartAutomating/PipeScript/blob/main/CHANGELOG.md)
'@
        }
    }
}

