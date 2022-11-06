---

title: PipeScript 0.1.3
sourceURL: https://github.com/StartAutomating/PipeScript/releases/tag/v0.1.3
tag: release
---
## 0.1.3:
* New Protocols: UDP (Fixes [#208](https://github.com/StartAutomating/PipeScript/issues/208))
* New Inline Language Support:
  * ADA (Fixes [#207](https://github.com/StartAutomating/PipeScript/issues/207))
  * Basic/VB/VBScript (Fixes [#206](https://github.com/StartAutomating/PipeScript/issues/206))
  * R (Fixes [#204](https://github.com/StartAutomating/PipeScript/issues/204))
  * SQL (Fixes [#200](https://github.com/StartAutomating/PipeScript/issues/200))
  * TCL/TK (Fixes [#205](https://github.com/StartAutomating/PipeScript/issues/205))
* Keyword improvements:
  * new keyword now allows static members as constructor arguments (Fixes [#214](https://github.com/StartAutomating/PipeScript/issues/214))
  * until keyword uses do{} until (Fixes [#217](https://github.com/StartAutomating/PipeScript/issues/217))
* General Improvements:
  * Core Transpiler now respects .Rank (Fixes [#210](https://github.com/StartAutomating/PipeScript/issues/210) [#211](https://github.com/StartAutomating/PipeScript/issues/211))
  * New-PipeScript:
    * Fixing -Link behavior (Fixes [#201](https://github.com/StartAutomating/PipeScript/issues/201))
    * Trimming ends of examples (Fixes [#202](https://github.com/StartAutomating/PipeScript/issues/202))
    * Plurally aliasing -Examples and -Links (Fixes [#203](https://github.com/StartAutomating/PipeScript/issues/203))
  * Search-PipeScript:
    * Now supports plural aliases for -RegularExpression (Fixes [#219](https://github.com/StartAutomating/PipeScript/issues/219))
* ParameterTypeConstraint now ignores [ordered] (Fixes [#190](https://github.com/StartAutomating/PipeScript/issues/190))
* Extended Type System Improvements:
  * [ScriptBlock].Transpile() now throws (Fixes [#212](https://github.com/StartAutomating/PipeScript/issues/212))
---

## 0.1.2:
* New Inline Language support
  * Batch support (Fixes [#198](https://github.com/StartAutomating/PipeScript/issues/198))
  * Bash Support  (Fixes [#194](https://github.com/StartAutomating/PipeScript/issues/194))
* Core Inline Transpiler : Adding -LinePattern (fixes [#197](https://github.com/StartAutomating/PipeScript/issues/197))
* New-PipeScript: Writing help (Fixes [#195](https://github.com/StartAutomating/PipeScript/issues/195)) and functions (fixes [#196](https://github.com/StartAutomating/PipeScript/issues/196))
* AST Type Improvements:
  * Adding [AST].Transpile() (Fixes [#192](https://github.com/StartAutomating/PipeScript/issues/192))
  * Considering a pipeline in a hashtable to be assigned (Fixes [#193](https://github.com/StartAutomating/PipeScript/issues/193))
  * [ScriptBlock]/[AST]:  Adding .Transpilers (Fixes [#185](https://github.com/StartAutomating/PipeScript/issues/185))
  * [CommandAst].ResolvedCommand:  Checking transpilers first (Fixes [#186](https://github.com/StartAutomating/PipeScript/issues/186))
* Improvements:
  * new keyword property bag improvements (Fixes [#191](https://github.com/StartAutomating/PipeScript/issues/191))
  * Use-PipeScript:  Defaulting to core transpiler (Fixes [#188](https://github.com/StartAutomating/PipeScript/issues/188))
  * Core Transpiler:  Allowing -ScriptBlock to be provided postionally (Fixes [#189](https://github.com/StartAutomating/PipeScript/issues/189))
  * Adding Hashtable formatter (Fixes [#187](https://github.com/StartAutomating/PipeScript/issues/187))
  * HTTP Protocol: Enabling Splatting (Fixes [#183](https://github.com/StartAutomating/PipeScript/issues/183))
  * Requiring Inline Transpilers accept [Management.Automation.CommandInfo] from the Pipeline (Fixes [#184](https://github.com/StartAutomating/PipeScript/issues/184))
---

## 0.1.1:
* New Keywords:
  * await (Fixes [#181](https://github.com/StartAutomating/PipeScript/issues/181))
* New-PipeScript:
  * Allowing -Parameter to be supplied via reflection (Fixes [#171](https://github.com/StartAutomating/PipeScript/issues/171))
  * Adding -ParameterHelp (Fixes [#172](https://github.com/StartAutomating/PipeScript/issues/172))
  * Adding -WeaklyTyped (Fixes [#174](https://github.com/StartAutomating/PipeScript/issues/174))
* Update-PipeScript:
  * Adding -RegexReplacement (Fixes [#178](https://github.com/StartAutomating/PipeScript/issues/178))
  * Adding -RegionReplacement (Fixes [#179](https://github.com/StartAutomating/PipeScript/issues/179))
* Use-PipeScript:
  * Supporting Get-Command -Syntax (Fixes [#177](https://github.com/StartAutomating/PipeScript/issues/177))
* Types/Formatting Fixes:
  * CommandAST/AttributeAST:  Adding .Args/.Arguments/.Parameters aliases (Fixes [#176](https://github.com/StartAutomating/PipeScript/issues/176))
  * CommandAST:  Fixing .GetParameter (Fixes [#175](https://github.com/StartAutomating/PipeScript/issues/175))
  * Updating PSToken control (more colorization) (Fixes [#166](https://github.com/StartAutomating/PipeScript/issues/166))
  * YAML Formatter indent / primitive support (Fixes [#180](https://github.com/StartAutomating/PipeScript/issues/180))
---

## 0.1:
* PipeScript can now Transpile Protocols (Fixes [#168](https://github.com/StartAutomating/PipeScript/issues/168))
* PipeScript can transpile http[s] protocol (Fixes [#169](https://github.com/StartAutomating/PipeScript/issues/169))
* PipeScript now formats the AST (Fixes [#166](https://github.com/StartAutomating/PipeScript/issues/166)) 
* Added .IsAssigned to CommandAST/PipelineAST (Fixes [#167](https://github.com/StartAutomating/PipeScript/issues/167))
---

## 0.0.14:
* New Transpilers:
  * [RemoveParameter] ([#159](https://github.com/StartAutomating/PipeScript/issues/159))
  * [RenameVariable] ([#160](https://github.com/StartAutomating/PipeScript/issues/160))  
* Keyword Updates:
  * new now supports extended type creation ([#164](https://github.com/StartAutomating/PipeScript/issues/164))
  * until now supports a TimeSpan, DateTime, or EventName string ([#153](https://github.com/StartAutomating/PipeScript/issues/153))
* AST Extended Type Enhancements:
  * [TypeConstraintAst] and [AttributeAst] now have .ResolvedCommand ([#162](https://github.com/StartAutomating/PipeScript/issues/162))
* Action Updates
  * Pulling just before push ([#163](https://github.com/StartAutomating/PipeScript/issues/163))
  * Not running when there is not a current branch ([#158](https://github.com/StartAutomating/PipeScript/issues/158))
  * Improving email determination ([#156](https://github.com/StartAutomating/PipeScript/issues/156))
* Invoke-PipeScript terminates transpiler errors when run interactively ([#161](https://github.com/StartAutomating/PipeScript/issues/161))
---

## 0.0.13:
* New / Improved Keywords 
  * assert keyword (Support for pipelines) ([#143](https://github.com/StartAutomating/PipeScript/issues/143))
  * new keyword (Support for ::Create method) ([#148](https://github.com/StartAutomating/PipeScript/issues/148))
  * until keyword ([#146](https://github.com/StartAutomating/PipeScript/issues/146)) 
* Syntax Improvements
  * Support for === ([#123](https://github.com/StartAutomating/PipeScript/issues/123)) (thanks @dfinke)
* New Inline PipeScript support:
  * Now Supporting Inline PipeScript in YAML ([#147](https://github.com/StartAutomating/PipeScript/issues/147))
* General Improvements:
  * Extending AST Types ([#145](https://github.com/StartAutomating/PipeScript/issues/145))
---

## 0.0.12:
* Adding assert keyword ([#143](https://github.com/StartAutomating/PipeScript/issues/143))
* Fixing new keyword for blank constructors ([#142](https://github.com/StartAutomating/PipeScript/issues/142) )
* Rest Transpiler:
  * Handling multiple QueryString values ([#139](https://github.com/StartAutomating/PipeScript/issues/139))
  * Only passing ContentType to invoker if invoker supports it ([#141](https://github.com/StartAutomating/PipeScript/issues/141))
  * Defaulting to JSON body when ContentType is unspecified ([#140](https://github.com/StartAutomating/PipeScript/issues/140))
---

## 0.0.11:
* Source Generators Now Support Parameters / Arguments ([#75](https://github.com/StartAutomating/PipeScript/issues/75))
* Invoke-PipeScript Terminating Build Errors ([#135](https://github.com/StartAutomating/PipeScript/issues/135))
---

## 0.0.10:
* Improvements:
  * REST transpiler
    * Supports Query/BodyParameter with AmbientValue and DefaultBindingProperty ([#119](https://github.com/StartAutomating/PipeScript/issues/119))
    * Improved Documentation
  * Logo ([#132](https://github.com/StartAutomating/PipeScript/issues/132))
* Bugfixes:
  * New-PipeScript ([#122](https://github.com/StartAutomating/PipeScript/issues/122))
    * Improving Improving inline documentation and [ScriptBlock] handling
  * Join-PipeScript ([#124](https://github.com/StartAutomating/PipeScript/issues/124))
    * Adding .Examples
    * Fixing parameter joining issues
---

## 0.0.9:
* New Features:
  * new keyword ([#128](https://github.com/StartAutomating/PipeScript/issues/128))
  * == operator ([#123](https://github.com/StartAutomating/PipeScript/issues/123) (thanks @dfinke))
* Fixes
  * REST Transpiler automatically coerces [DateTime] and [switch] parameters ([#118](https://github.com/StartAutomating/PipeScript/issues/118))
  * Join-PipeScript:  Fixing multiparam error ([#124](https://github.com/StartAutomating/PipeScript/issues/124))
  * ValidateScriptBlock:  Only validing ScriptBlocks ([#125](https://github.com/StartAutomating/PipeScript/issues/125))
---
## 0.0.8:
* New Commands:
  * New-PipeScript ([#94](https://github.com/StartAutomating/PipeScript/issues/94))
  * Search-PipeScript ([#115](https://github.com/StartAutomating/PipeScript/issues/115))
* New Transpilers:
  * REST ([#114](https://github.com/StartAutomating/PipeScript/issues/114))
  * Inline.Kotlin ([#110](https://github.com/StartAutomating/PipeScript/issues/110))
* Bugfixes and improvements:
  * Fixing Help Generation ([#56](https://github.com/StartAutomating/PipeScript/issues/56))
  * Anchoring match for Get-Transpiler ([#109](https://github.com/StartAutomating/PipeScript/issues/109))
  * Core Inline Transpiler Cleanup ([#111](https://github.com/StartAutomating/PipeScript/issues/111))
  * Shared Context within Inline Transpilers ([#112](https://github.com/StartAutomating/PipeScript/issues/112))
  * Fixing Include Transpiler Pattern ([#96](https://github.com/StartAutomating/PipeScript/issues/96))
  * Join-PipeScript interactive .Substring error ([#116](https://github.com/StartAutomating/PipeScript/issues/116))
---

## 0.0.7:
* Syntax Improvements:
  * Support for Dot Notation ([#107](https://github.com/StartAutomating/PipeScript/issues/107))
* New Transpilers:
  * .>ModuleRelationships ([#105](https://github.com/StartAutomating/PipeScript/issues/105))
  * .>ModuleExports ([#104](https://github.com/StartAutomating/PipeScript/issues/104))
  * .>Aliases ([#106](https://github.com/StartAutomating/PipeScript/issues/106))
* Fixes:
  * Invoke-PipeScript improved error behavior ([#103](https://github.com/StartAutomating/PipeScript/issues/103))
  * Explicit Transpiler returns modified ScriptBlock ([#102](https://github.com/StartAutomating/PipeScript/issues/102))
  * .psm1 alias export fix ([#100](https://github.com/StartAutomating/PipeScript/issues/100))
  * Include improvements ([#96](https://github.com/StartAutomating/PipeScript/issues/96))
---

## 0.0.6:
* New Transpilers:
  * ValidateScriptBlock
* Improved Transpilers:
  * [Include] not including source generators ([#96](https://github.com/StartAutomating/PipeScript/issues/96))
* PipeScript.psm1 is now build with PipeScript ([#95](https://github.com/StartAutomating/PipeScript/issues/95))
* Join-PipeScript:  Fixing -BlockType ([#97](https://github.com/StartAutomating/PipeScript/issues/97))
* GitHub Action will now look for PipeScript.psd1 in the workspace first ([#98](https://github.com/StartAutomating/PipeScript/issues/98))
---

## 0.0.5
* New Language Features:
  * PipedAssignment ([#88](https://github.com/StartAutomating/PipeScript/issues/88))
* Command Fixes:
  * Invoke-PipeScript now defaults unmapped files to treating them as PowerShell / PipeScript ([#86](https://github.com/StartAutomating/PipeScript/issues/86))
* Improved Transpilers:
  * .>PipeScript.Inline now supports -StartPattern/-EndPattern ([#85](https://github.com/StartAutomating/PipeScript/issues/85))
  * Inline Transpilers now use -StartPattern/-EndPattern ([#85](https://github.com/StartAutomating/PipeScript/issues/85))
* Inline PipeScript Support for New Languages
  * .>Inline.PSD1 ([#89](https://github.com/StartAutomating/PipeScript/issues/89))
  * .>Inline.XML now handles .PS1XML ([#91](https://github.com/StartAutomating/PipeScript/issues/91))
---

## 0.0.4
* New Transpilers:
  * .>RegexLiteral ([#77](https://github.com/StartAutomating/PipeScript/issues/77))
* Improved Transpilers:
  * .>PipeScript.Inline now supports -ReplacePattern ([#84](https://github.com/StartAutomating/PipeScript/issues/84))
  * .>Include now supports wildcards ([#81](https://github.com/StartAutomating/PipeScript/issues/81))
* Inline PipeScript Support for New Languages
  * ATOM ([#79](https://github.com/StartAutomating/PipeScript/issues/79))
  * Bicep ([#73](https://github.com/StartAutomating/PipeScript/issues/73))
  * HLSL ([#76](https://github.com/StartAutomating/PipeScript/issues/76))
  * Perl / POD ([#74](https://github.com/StartAutomating/PipeScript/issues/74))
  * RSS ([#80](https://github.com/StartAutomating/PipeScript/issues/80))

---
## 0.0.3
* New Transpilers:
  * .>ValidateExtension ([#64](https://github.com/StartAutomating/PipeScript/issues/64))
  * .>OutputFile ([#53](https://github.com/StartAutomating/PipeScript/issues/53))
* Inline PipeScript Support for New Languages
  * Python ([#63](https://github.com/StartAutomating/PipeScript/issues/63))
  * PHP ([#67](https://github.com/StartAutomating/PipeScript/issues/67))
  * Razor ([#68](https://github.com/StartAutomating/PipeScript/issues/68))
* Bugfixes / improvements:
  * Plugged Invoke-PipeScript Parameter Leak ([#69](https://github.com/StartAutomating/PipeScript/issues/69))
  * .>ValidateTypes transpiler now returns true ([#65](https://github.com/StartAutomating/PipeScript/issues/65))
  * .>ValidateTypes transpiler now can apply to a [VariableExpressionAST] ([#66](https://github.com/StartAutomating/PipeScript/issues/66))
* Building PipeScript with PipeScript ([#54](https://github.com/StartAutomating/PipeScript/issues/54))
---

## 0.0.2
* New Transpilers:
  * .>ValidatePlatform ([#58](https://github.com/StartAutomating/PipeScript/issues/58))
  * .>ValidatePropertyName ([#59](https://github.com/StartAutomating/PipeScript/issues/59))
  * .>Inline.ObjectiveC ([#60](https://github.com/StartAutomating/PipeScript/issues/60))
* Transpiler Fixes
  * .>VBN now supports -Position ([#57](https://github.com/StartAutomating/PipeScript/issues/57))
* GitHub Action Bugfix ([#55](https://github.com/StartAutomating/PipeScript/issues/55))
---
## 0.0.1
Initial Commit.
