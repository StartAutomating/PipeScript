These are all of the transpilers currently included in PipeScript:



|Name                                                                                       |Synopsis                                          |
|-------------------------------------------------------------------------------------------|--------------------------------------------------|
|[Aliases](Transpilers/Parameters/Aliases.psx.ps1)                                          |Dynamically Defines Aliases                       |
|[All](Transpilers/Keywords/All.psx.ps1)                                                    |all keyword                                       |
|[ArrowOperator](Transpilers/Syntax/ArrowOperator.psx.ps1)                                  |Arrow Operator                                    |
|[Assert](Transpilers/Keywords/Assert.psx.ps1)                                              |Assert keyword                                    |
|[Await](Transpilers/Keywords/Await.psx.ps1)                                                |awaits asynchronous operations                    |
|[Bash](Transpilers/Wrappers/Bash.psx.ps1)                                                  |Wraps PowerShell in a Bash Script                 |
|[Batch](Transpilers/Wrappers/Batch.psx.ps1)                                                |Wraps PowerShell in a Windows Batch Script        |
|[BatchPowerShell](Transpilers/Wrappers/BatchPowerShell.psx.ps1)                            |Wraps PowerShell in a Windows Batch Script        |
|[ConditionalKeyword](Transpilers/Syntax/ConditionalKeyword.psx.ps1)                        |Conditional Keyword Expansion                     |
|[Decorate](Transpilers/Decorate.psx.ps1)                                                   |decorate transpiler                               |
|[Define](Transpilers/Define.psx.ps1)                                                       |Defines a variable                                |
|[Dot](Transpilers/Syntax/Dot.psx.ps1)                                                      |Dot Notation                                      |
|[EqualityComparison](Transpilers/Syntax/EqualityComparison.psx.ps1)                        |Allows equality comparison.                       |
|[EqualityTypeComparison](Transpilers/Syntax/EqualityTypeComparison.psx.ps1)                |Allows equality type comparison.                  |
|[Explicit](Transpilers/Explicit.psx.ps1)                                                   |Makes Output from a PowerShell function Explicit. |
|[Help](Transpilers/Help.psx.ps1)                                                           |Help Transpiler                                   |
|[Include](Transpilers/Include.psx.ps1)                                                     |Includes Files                                    |
|[Inherit](Transpilers/Inherit.psx.ps1)                                                     |Inherits a Command                                |
|[Java.Template](Transpilers/Templates/Java.Template.psx.ps1)                               |Java Template Transpiler.                         |
|[JavaScript.Template](Transpilers/Templates/JavaScript.Template.psx.ps1)                   |JavaScript Template Transpiler.                   |
|[Json.Template](Transpilers/Templates/Json.Template.psx.ps1)                               |JSON PipeScript Transpiler.                       |
|[Kotlin.Template](Transpilers/Templates/Kotlin.Template.psx.ps1)                           |Kotlin Template Transpiler.                       |
|[Kusto.Template](Transpilers/Templates/Kusto.Template.psx.ps1)                             |Kusto Template Transpiler.                        |
|[Latex.Template](Transpilers/Templates/Latex.Template.psx.ps1)                             |Latex Template Transpiler.                        |
|[LUA.Template](Transpilers/Templates/LUA.Template.psx.ps1)                                 |LUA Template Transpiler.                          |
|[Markdown.Template](Transpilers/Templates/Markdown.Template.psx.ps1)                       |Markdown Template Transpiler.                     |
|[ModuleExports](Transpilers/Modules/ModuleExports.psx.ps1)                                 |Gets Module Exports                               |
|[ModuleRelationship](Transpilers/Modules/ModuleRelationship.psx.ps1)                       |Gets Module Relationships                         |
|[NamespacedAlias](Transpilers/Syntax/NamespacedAlias.psx.ps1)                              |Declares a namespaced alias                       |
|[NamespacedFunction](Transpilers/Syntax/NamespacedFunction.psx.ps1)                        |Namespaced functions                              |
|[New](Transpilers/Keywords/New.psx.ps1)                                                    |'new' keyword                                     |
|[ObjectiveC.Template](Transpilers/Templates/ObjectiveC.Template.psx.ps1)                   |Objective Template Transpiler.                    |
|[OpenSCAD.Template](Transpilers/Templates/OpenSCAD.Template.psx.ps1)                       |OpenSCAD Template Transpiler.                     |
|[OutputFile](Transpilers/OutputFile.psx.ps1)                                               |Outputs to a File                                 |
|[Perl.Template](Transpilers/Templates/Perl.Template.psx.ps1)                               |Perl Template Transpiler.                         |
|[PHP.Template](Transpilers/Templates/PHP.Template.psx.ps1)                                 |PHP Template Transpiler.                          |
|[PipedAssignment](Transpilers/Syntax/PipedAssignment.psx.ps1)                              |Piped Assignment Transpiler                       |
|[PipeScript.Aspect](Transpilers/Core/PipeScript.Aspect.psx.ps1)                            |Aspect Transpiler                                 |
|[PipeScript.AttributedExpression](Transpilers/Core/PipeScript.AttributedExpression.psx.ps1)|The PipeScript AttributedExpression Transpiler    |
|[Pipescript.FunctionDefinition](Transpilers/Core/Pipescript.FunctionDefinition.psx.ps1)    |PipeScript Function Transpiler                    |
|[PipeScript.ParameterAttribute](Transpilers/Core/PipeScript.ParameterAttribute.psx.ps1)    |
|[PipeScript.Protocol](Transpilers/Core/PipeScript.Protocol.psx.ps1)                        |Core Protocol Transpiler                          |
|[Pipescript](Transpilers/Core/Pipescript.psx.ps1)                                          |The Core PipeScript Transpiler                    |
|[PipeScript.Template](Transpilers/Core/PipeScript.Template.psx.ps1)                        |Template Transpiler                               |
|[PipeScript.TypeConstraint](Transpilers/Core/PipeScript.TypeConstraint.psx.ps1)            |Transpiles Type Constraints                       |
|[PipeScript.TypeExpression](Transpilers/Core/PipeScript.TypeExpression.psx.ps1)            |The PipeScript TypeExpression Transpiler          |
|[ProxyCommand](Transpilers/ProxyCommand.psx.ps1)                                           |Creates Proxy Commands                            |
|[PS1XML.Template](Transpilers/Templates/PS1XML.Template.psx.ps1)                           |PS1XML Template Transpiler.                       |
|[PSD1.Template](Transpilers/Templates/PSD1.Template.psx.ps1)                               |PSD1 Template Transpiler.                         |
|[Python.Template](Transpilers/Templates/Python.Template.psx.ps1)                           |Python Template Transpiler.                       |
|[R.Template](Transpilers/Templates/R.Template.psx.ps1)                                     |R Template Transpiler.                            |
|[Racket.Template](Transpilers/Templates/Racket.Template.psx.ps1)                           |Racket Template Transpiler.                       |
|[Razor.Template](Transpilers/Templates/Razor.Template.psx.ps1)                             |Razor Template Transpiler.                        |
|[RegexLiteral](Transpilers/Syntax/RegexLiteral.psx.ps1)                                    |Regex Literal Transpiler                          |
|[RemoveParameter](Transpilers/Parameters/RemoveParameter.psx.ps1)                          |Removes Parameters from a ScriptBlock             |
|[RenameVariable](Transpilers/RenameVariable.psx.ps1)                                       |Renames variables                                 |
|[Requires](Transpilers/Keywords/Requires.psx.ps1)                                          |requires one or more modules, variables, or types.|
|[Rest](Transpilers/Rest.psx.ps1)                                                           |Generates PowerShell to talk to a REST api.       |
|[RSS.Template](Transpilers/Templates/RSS.Template.psx.ps1)                                 |RSS Template Transpiler.                          |
|[Ruby.Template](Transpilers/Templates/Ruby.Template.psx.ps1)                               |Ruby Template Transpiler.                         |
|[Scala.Template](Transpilers/Templates/Scala.Template.psx.ps1)                             |Scala Template Transpiler.                        |
|[SQL.Template](Transpilers/Templates/SQL.Template.psx.ps1)                                 |SQL Template Transpiler.                          |
|[SVG.template](Transpilers/Templates/SVG.template.psx.ps1)                                 |SVG Template Transpiler.                          |
|[TCL.Template](Transpilers/Templates/TCL.Template.psx.ps1)                                 |TCL/TK Template Transpiler.                       |
|[TOML.Template](Transpilers/Templates/TOML.Template.psx.ps1)                               |TOML Template Transpiler.                         |
|[TypeScript.Template](Transpilers/Templates/TypeScript.Template.psx.ps1)                   |TypeScript Template Transpiler.                   |
|[Until](Transpilers/Keywords/Until.psx.ps1)                                                |until keyword                                     |
|[ValidateExtension](Transpilers/Parameters/ValidateExtension.psx.ps1)                      |Validates Extensions                              |
|[ValidatePlatform](Transpilers/Parameters/ValidatePlatform.psx.ps1)                        |Validates the Platform                            |
|[ValidatePropertyName](Transpilers/Parameters/ValidatePropertyName.psx.ps1)                |Validates Property Names                          |
|[ValidateScriptBlock](Transpilers/Parameters/ValidateScriptBlock.psx.ps1)                  |Validates Script Blocks                           |
|[ValidateTypes](Transpilers/Parameters/ValidateTypes.psx.ps1)                              |Validates if an object is one or more types.      |
|[ValidValues](Transpilers/Parameters/ValidValues.psx.ps1)                                  |Dynamically Defines ValidateSet attributes        |
|[VBN](Transpilers/Parameters/VBN.psx.ps1)                                                  |ValueFromPiplineByPropertyName Shorthand          |
|[VFP](Transpilers/Parameters/VFP.psx.ps1)                                                  |ValueFromPipline Shorthand                        |
|[WebAssembly.Template](Transpilers/Templates/WebAssembly.Template.psx.ps1)                 |WebAssembly Template Transpiler.                  |
|[WhereMethod](Transpilers/Syntax/WhereMethod.psx.ps1)                                      |Where Method                                      |
|[XAML.Template](Transpilers/Templates/XAML.Template.psx.ps1)                               |XAML Template Transpiler.                         |
|[XML.Template](Transpilers/Templates/XML.Template.psx.ps1)                                 |XML Template Transpiler.                          |
|[YAML.Template](Transpilers/Templates/YAML.Template.psx.ps1)                               |Yaml Template Transpiler.                         |
