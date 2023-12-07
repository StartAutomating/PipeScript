@{
    ModuleVersion     = '0.2.6'
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
    FunctionsToExport = 'Get-Transpiler','Start-PSNode','PipeScript.Optimizer.ConsolidateAspects','Signal.Nothing','Signal.Out','Language.SQL','Language.Bicep','Language.Lua','Language.Kusto','Language.Markdown','Language.GLSL','Language.Rust','Language.WebAssembly','Language.XML','Language.TypeScript','Language.Razor','Language.Docker','Language.Racket','Language.RSS','Language.CSharp','Language.ADA','Language.Perl','Language.JSON','Language.Ruby','Language.ATOM','Language.OpenSCAD','Language.TCL','Language.R','Language.Eiffel','Language.Dart','Language.CPlusPlus','Language.PowerShellData','Language.PowerShellXML','Language.BASIC','Language.TOML','Language.Haxe','Language.Go','Language.Scala','Language.LaTeX','Language.Batch','Language.HTML','Language.SVG','Language.HLSL','Language.Vue','Language.Bash','Language.PHP','Language.Java','Language.ObjectiveC','Language.JavaScript','Template.DoLoop.js','Template.ForEachLoop.js','Template.ForLoop.js','Template.Function.js','Template.InvokeMethod.js','Template.Method.js','Template.RegexLiteral.js','Template.TryCatch.js','Template.WhileLoop.js','Language.XAML','Language.Arduino','Language.Kotlin','Language.Python','Language.CSS','Language.HCL','Language.YAML','Language.XSL','Export-Json','Import-Json','Parse.CSharp','Parse.PowerShell','ConvertFrom-CliXml','ConvertTo-CliXml','Route.Uptime','Route.VersionInfo','Aspect.DynamicParameter','Aspect.ModuleExtensionType','Aspect.ModuleExtensionPattern','Aspect.ModuleExtensionCommand','Aspect.GroupObjectByTypeName','Aspect.GroupObjectByType','PipeScript.PostProcess.InitializeAutomaticVariables','PipeScript.PostProcess.PartialFunction','PipeScript.Automatic.Variable.IsPipedTo','PipeScript.Automatic.Variable.IsPipedFrom','PipeScript.Automatic.Variable.MyCallstack','PipeScript.Automatic.Variable.MySelf','PipeScript.Automatic.Variable.MyParameters','PipeScript.Automatic.Variable.MyCaller','PipeScript.Automatic.Variable.MyCommandAst','Compile.LanguageDefinition','Export-Pipescript','Get-PipeScript','Import-PipeScript','Invoke-PipeScript','Join-PipeScript','New-PipeScript','Search-PipeScript','Update-PipeScript','Use-PipeScript','Import-ModuleMember','Invoke-Interpreter','Protocol.HTTP','Protocol.JSONSchema','Protocol.OpenAPI','Protocol.UDP'
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
## PipeScript 0.2.6:

* PipeScript can now be sponsored! (please show your support) (#488)

* PipeScript now has several formalized command types (#452)
  * Aspects
    * DynamicParameters (#462)
    * ModuleExtensionType (#460)
    * ModuleExtensionPattern (#460)
    * ModuleExtensionCommand (#460)  
  * Automatic Variables (Fixes #426)
    * $MySelf
    * $MyParameters
    * $MyCallstack
    * $MyCaller 
    * $MyCommandAst (#434)
    * $IsPipedTo (#430)
    * $IsPipedFrom (#431)
  * PostProcessing/Optimization now applies to Functions (#432)
    * Partial functions are now a PostProcessor (#449)
  * Protocol Functions
     * Made HTTP, UDP, and JSON Schema Protocols into functions (#474)
     * Added OpenAPI Protocol (#457)
* Core Command Improvements
  * Get-PipeScript is now built with PipeScript (#463)
  * Export-PipeScript
    * Is _much_ more transparent in GitHub Workflow (#438)
    * Now lists all files built, time to build each, transpilers used, and PipeScript factor.
    * Auto Installs simple #requires in build files (#491)
  * Update-PipeScript uses AST Based Offsets (#439)
  * New-PipeScript
    * Making Description/Synopis ValueFromPipelineByPropertyName (#453)
    * Adding -InputObject parameter.
    * Making -Parameter _much_ more open-ended (#454)
    * Improving Reflection Support (#467)
    * Allowing -Parameter as `[CommandInfo]`/`[CommandMetaData]` (#477)
    * Supporting DefaultValue/ValidValue (Fixes #473)
    * Adding -Verb/-Noun (#468)
  * Invoke-PipeScript
    * Improving Positional Attribute Parameters (Fixes #70)
    * Clarifying 'Transpiler Not Found' Messages (#484)  

* Sentence Parsing Support
  * Improving Mutliword alias support (#444)
  * Adding Clause.ParameterValues (#445)
  * Allowing N words to be skipped (#479)

* 'All' Improvements
  * Expanding Syntax for 'All' (#436)
  * Compacting generating code (#440)
  * Adding Greater Than / Less Than aliases (#446)
  * Enabling 'should' (#448)
  * 'all applications in $path' (#475)  

* New Transpilers:
  * ValidValues (#451)
  * Adding WhereMethod (#465)
  * Adding ArrowOperator/ Lambdas ! (#464)

* Extended Type Improvements
  * VariableExpressionAst.GetVariableType - Enabling InvokeMemberExpression (#490)
  * CommandInfo.BlockComments - Resolving aliases (#487)
  * CommandInfo.GetHelpField - Skipping additional script blocks (Fixes #486)

* Minor Fixes:
  * Requires is now Quieter (#433)
  * Appending Unmapped Locations to Alias Namespace (Fixes #427)  
  * Fixing Examples in New-PipeScript (thanks @ninmonkey !)  
  * Namespaced Alias/Function - Not Transpiling if command found (#455)  
  * Automatically Testing Examples (greatly expanded test coverage) (#461)
  * Templates now report errors more accurately (#489)
  * Inherit - Fixing Abstract/Dynamic Inheritance (#480)
  * Include - Allowing Including URLs (#481)
  * Partial Functions will not join their headers (#483)
---
            
Additional history in [CHANGELOG](https://pipescript.start-automating.com/CHANGELOG)
'@
        }
    }
}

