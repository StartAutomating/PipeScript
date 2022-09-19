These are all of the transpilers currently included in PipeScript:



|Name                                                                                             |Synopsis                                         |
|-------------------------------------------------------------------------------------------------|-------------------------------------------------|
|[Aliases](Transpilers/Parameters/Aliases.psx.ps1)                                                |Dynamically Defines Aliases                      |
|[Assert](Transpilers/Keywords/Assert.psx.ps1)                                                    |Assert keyword                                   |
|[Await](Transpilers/Keywords/Await.psx.ps1)                                                      |awaits asynchronous operations                   |
|[Bash](Transpilers/Wrappers/Bash.psx.ps1)                                                        |Wraps PowerShell in a Bash Script                |
|[Batch](Transpilers/Wrappers/Batch.psx.ps1)                                                      |Wraps PowerShell in a Windows Batch Script       |
|[BatchPowerShell](Transpilers/Wrappers/BatchPowerShell.psx.ps1)                                  |Wraps PowerShell in a Windows Batch Script       |
|[Decorate](Transpilers/Decorate.psx.ps1)                                                         |decorate transpiler                              |
|[Dot](Transpilers/Syntax/Dot.psx.ps1)                                                            |Dot Notation                                     |
|[EqualityComparison](Transpilers/Syntax/EqualityComparison.psx.ps1)                              |Allows equality comparison.                      |
|[EqualityTypeComparison](Transpilers/Syntax/EqualityTypeComparison.psx.ps1)                      |Allows equality type comparison.                 |
|[Explicit](Transpilers/Explicit.psx.ps1)                                                         |Makes Output from a PowerShell function Explicit.|
|[Help](Transpilers/Help.psx.ps1)                                                                 |Help Transpiler                                  |
|[Http.Protocol](Transpilers/Protocols/Http.Protocol.psx.ps1)                                     |http protocol                                    |
|[Include](Transpilers/Include.psx.ps1)                                                           |Includes Files                                   |
|[Inline.ADA](Transpilers/Inline/Inline.ADA.psx.ps1)                                              |ADA PipeScript Transpiler.                       |
|[Inline.ATOM](Transpilers/Inline/Inline.ATOM.psx.ps1)                                            |ATOM Inline PipeScript Transpiler.               |
|[Inline.Bash](Transpilers/Inline/Inline.Bash.psx.ps1)                                            |Bash PipeScript Transpiler.                      |
|[Inline.Basic](Transpilers/Inline/Inline.Basic.psx.ps1)                                          |Basic PipeScript Transpiler.                     |
|[Inline.Batch](Transpilers/Inline/Inline.Batch.psx.ps1)                                          |Batch PipeScript Transpiler.                     |
|[Inline.Bicep](Transpilers/Inline/Inline.Bicep.psx.ps1)                                          |Bicep Inline PipeScript Transpiler.              |
|[Inline.CPlusPlus](Transpilers/Inline/Inline.CPlusPlus.psx.ps1)                                  |C/C++ PipeScript Transpiler.                     |
|[Inline.CSharp](Transpilers/Inline/Inline.CSharp.psx.ps1)                                        |C# Inline PipeScript Transpiler.                 |
|[Inline.CSS](Transpilers/Inline/Inline.CSS.psx.ps1)                                              |CSS Inline PipeScript Transpiler.                |
|[Inline.Go](Transpilers/Inline/Inline.Go.psx.ps1)                                                |Go PipeScript Transpiler.                        |
|[Inline.HLSL](Transpilers/Inline/Inline.HLSL.psx.ps1)                                            |HLSL Inline PipeScript Transpiler.               |
|[Inline.HTML](Transpilers/Inline/Inline.HTML.psx.ps1)                                            |HTML PipeScript Transpiler.                      |
|[Inline.Java](Transpilers/Inline/Inline.Java.psx.ps1)                                            |Java Inline PipeScript Transpiler.               |
|[Inline.JavaScript](Transpilers/Inline/Inline.JavaScript.psx.ps1)                                |JavaScript Inline PipeScript Transpiler.         |
|[Inline.Json](Transpilers/Inline/Inline.Json.psx.ps1)                                            |JSON PipeScript Transpiler.                      |
|[Inline.Kotlin](Transpilers/Inline/Inline.Kotlin.psx.ps1)                                        |Kotlin Inline PipeScript Transpiler.             |
|[Inline.Markdown](Transpilers/Inline/Inline.Markdown.psx.ps1)                                    |Markdown File Transpiler.                        |
|[Inline.ObjectiveC](Transpilers/Inline/Inline.ObjectiveC.psx.ps1)                                |Objective C PipeScript Transpiler.               |
|[Inline.OpenSCAD](Transpilers/Inline/Inline.OpenSCAD.psx.ps1)                                    |OpenSCAD Inline PipeScript Transpiler.           |
|[Inline.Perl](Transpilers/Inline/Inline.Perl.psx.ps1)                                            |Perl Inline PipeScript Transpiler.               |
|[Inline.PHP](Transpilers/Inline/Inline.PHP.psx.ps1)                                              |PHP PipeScript Transpiler.                       |
|[Inline.PSD1](Transpilers/Inline/Inline.PSD1.psx.ps1)                                            |PSD1 Inline PipeScript Transpiler.               |
|[Inline.Python](Transpilers/Inline/Inline.Python.psx.ps1)                                        |Python Inline PipeScript Transpiler.             |
|[Inline.R](Transpilers/Inline/Inline.R.psx.ps1)                                                  |R PipeScript Transpiler.                         |
|[Inline.Razor](Transpilers/Inline/Inline.Razor.psx.ps1)                                          |Razor Inline PipeScript Transpiler.              |
|[Inline.RSS](Transpilers/Inline/Inline.RSS.psx.ps1)                                              |RSS Inline PipeScript Transpiler.                |
|[Inline.Ruby](Transpilers/Inline/Inline.Ruby.psx.ps1)                                            |Ruby Inline PipeScript Transpiler.               |
|[Inline.Rust](Transpilers/Inline/Inline.Rust.psx.ps1)                                            |Rust Inline PipeScript Transpiler.               |
|[Inline.SQL](Transpilers/Inline/Inline.SQL.psx.ps1)                                              |SQL PipeScript Transpiler.                       |
|[Inline.TCL](Transpilers/Inline/Inline.TCL.psx.ps1)                                              |TCL/TK PipeScript Transpiler.                    |
|[Inline.TOML](Transpilers/Inline/Inline.TOML.psx.ps1)                                            |TOML Inline PipeScript Transpiler.               |
|[Inline.TypeScript](Transpilers/Inline/Inline.TypeScript.psx.ps1)                                |TypeScript Inline PipeScript Transpiler.         |
|[Inline.XML](Transpilers/Inline/Inline.XML.psx.ps1)                                              |XML Inline PipeScript Transpiler.                |
|[Inline.YAML](Transpilers/Inline/Inline.YAML.psx.ps1)                                            |Yaml File Transpiler.                            |
|[ModuleExports](Transpilers/Modules/ModuleExports.psx.ps1)                                       |Gets Module Exports                              |
|[ModuleRelationship](Transpilers/Modules/ModuleRelationship.psx.ps1)                             |Gets Module Relationships                        |
|[New](Transpilers/Keywords/New.psx.ps1)                                                          |'new' keyword                                    |
|[OutputFile](Transpilers/OutputFile.psx.ps1)                                                     |Outputs to a File                                |
|[PipedAssignment](Transpilers/Syntax/PipedAssignment.psx.ps1)                                    |Piped Assignment Transpiler                      |
|[PipeScript.AttributedExpression](Transpilers/Core/PipeScript.AttributedExpression.psx.ps1)      |The PipeScript AttributedExpression Transpiler   |
|[Pipescript.FunctionDefinition](Transpilers/Core/Pipescript.FunctionDefinition.psx.ps1)          |PipeScript Function Transpiler                   |
|[PipeScript.Inline](Transpilers/Core/PipeScript.Inline.psx.ps1)                                  |Inline Transpiler                                |
|[PipeScript.ParameterAttribute](Transpilers/Core/PipeScript.ParameterAttribute.psx.ps1)          |
|[PipeScript.ParameterTypeConstraint](Transpilers/Core/PipeScript.ParameterTypeConstraint.psx.ps1)|Transpiles Parameter Type Constraints            |
|[PipeScript.Protocol](Transpilers/Core/PipeScript.Protocol.psx.ps1)                              |Core Protocol Transpiler                         |
|[Pipescript](Transpilers/Core/Pipescript.psx.ps1)                                                |The Core PipeScript Transpiler                   |
|[PipeScript.TypeExpression](Transpilers/Core/PipeScript.TypeExpression.psx.ps1)                  |The PipeScript TypeExpression Transpiler         |
|[ProxyCommand](Transpilers/ProxyCommand.psx.ps1)                                                 |Creates Proxy Commands                           |
|[RegexLiteral](Transpilers/Syntax/RegexLiteral.psx.ps1)                                          |Regex Literal Transpiler                         |
|[RemoveParameter](Transpilers/Parameters/RemoveParameter.psx.ps1)                                |Removes Parameters from a ScriptBlock            |
|[RenameVariable](Transpilers/RenameVariable.psx.ps1)                                             |Renames variables                                |
|[Rest](Transpilers/Rest.psx.ps1)                                                                 |Generates PowerShell to talk to a REST api.      |
|[UDP.Protocol](Transpilers/Protocols/UDP.Protocol.psx.ps1)                                       |udp protocol                                     |
|[Until](Transpilers/Keywords/Until.psx.ps1)                                                      |until keyword                                    |
|[ValidateExtension](Transpilers/Parameters/ValidateExtension.psx.ps1)                            |Validates Extensions                             |
|[ValidatePlatform](Transpilers/Parameters/ValidatePlatform.psx.ps1)                              |Validates the Platform                           |
|[ValidatePropertyName](Transpilers/Parameters/ValidatePropertyName.psx.ps1)                      |Validates Property Names                         |
|[ValidateScriptBlock](Transpilers/Parameters/ValidateScriptBlock.psx.ps1)                        |Validates Script Blocks                          |
|[ValidateTypes](Transpilers/Parameters/ValidateTypes.psx.ps1)                                    |Validates if an object is one or more types.     |
|[VBN](Transpilers/Parameters/VBN.psx.ps1)                                                        |ValueFromPiplineByPropertyName Shorthand         |
|[VFP](Transpilers/Parameters/VFP.psx.ps1)                                                        |ValueFromPipline Shorthand                       |



