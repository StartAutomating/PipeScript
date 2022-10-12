---

title: PipeScript 0.1.6
sourceURL: https://github.com/StartAutomating/PipeScript/releases/tag/v0.1.6
tag: release
---
## 0.1.6:
* Added 'all' keyword (iterate over everything) (Fixes #244).  
* Added Natural Language Processing to CommandAST (Fixes #242)
* New Language Support:
  * HashiCorp Language (HCL) (Fixes #240 / #241)
  * WebAssembly (WAT) (Fixes #239)
---

## 0.1.5:
* Support for [inherit]ing a command (Fixes #235) (finally/wow)
* Join-PipeScript:  Overhauling (Fixes #231 Fixes #232 Fixes #233 Fixes #236)
* [Management.Automation.Language] type extensions: Adding .Script property and .ToString() scriptmethod (Fixes #234)
---

## 0.1.4:
* ValidateScriptBlock improvements
  * Adding -NoLoop/-NoWhileLoop (Fixes #227)
  * Adding -IncludeCommand/-ExcludeCommand (Fixes #224)
  * Adding -IncludeType/-ExcludeType (Fixes #225)
  * Adding -AstCondition (Fixes #226)
* Improved documentation of [decorate] transpiler (Fixes #222)
* Core Parameter Transpiler no longer considers real types (Fixes #223)
* Adding new value for PipeScript.PipeScriptType: BuildScript (Fixes #228)
---

## 0.1.3:
* New Protocols: UDP (Fixes #208)
* New Inline Language Support:
  * ADA (Fixes #207)
  * Basic/VB/VBScript (Fixes #206)
  * R (Fixes #204)
  * SQL (Fixes #200)
  * TCL/TK (Fixes #205)
* Keyword improvements:
  * new keyword now allows static members as constructor arguments (Fixes #214)
  * until keyword uses do{} until (Fixes #217)
* General Improvements:
  * Core Transpiler now respects .Rank (Fixes #210 #211)
  * New-PipeScript:
    * Fixing -Link behavior (Fixes #201)
    * Trimming ends of examples (Fixes #202)
    * Plurally aliasing -Examples and -Links (Fixes #203)
  * Search-PipeScript:
    * Now supports plural aliases for -RegularExpression (Fixes #219)
* ParameterTypeConstraint now ignores [ordered] (Fixes #190)
* Extended Type System Improvements:
  * [ScriptBlock].Transpile() now throws (Fixes #212)
---

## 0.1.2:
* New Inline Language support
  * Batch support (Fixes #198)
  * Bash Support  (Fixes #194)
* Core Inline Transpiler : Adding -LinePattern (fixes #197)
* New-PipeScript: Writing help (Fixes #195) and functions (fixes #196)
* AST Type Improvements:
  * Adding [AST].Transpile() (Fixes #192)
  * Considering a pipeline in a hashtable to be assigned (Fixes #193)
  * [ScriptBlock]/[AST]:  Adding .Transpilers (Fixes #185)
  * [CommandAst].ResolvedCommand:  Checking transpilers first (Fixes #186)
* Improvements:
  * new keyword property bag improvements (Fixes #191)
  * Use-PipeScript:  Defaulting to core transpiler (Fixes #188)
  * Core Transpiler:  Allowing -ScriptBlock to be provided postionally (Fixes #189)
  * Adding Hashtable formatter (Fixes #187)
  * HTTP Protocol: Enabling Splatting (Fixes #183)
  * Requiring Inline Transpilers accept [Management.Automation.CommandInfo] from the Pipeline (Fixes #184)
---

## 0.1.1:
* New Keywords:
  * await (Fixes #181)
* New-PipeScript:
  * Allowing -Parameter to be supplied via reflection (Fixes #171)
  * Adding -ParameterHelp (Fixes #172)
  * Adding -WeaklyTyped (Fixes #174)
* Update-PipeScript:
  * Adding -RegexReplacement (Fixes #178)
  * Adding -RegionReplacement (Fixes #179)
* Use-PipeScript:
  * Supporting Get-Command -Syntax (Fixes #177)
* Types/Formatting Fixes:
  * CommandAST/AttributeAST:  Adding .Args/.Arguments/.Parameters aliases (Fixes #176)
  * CommandAST:  Fixing .GetParameter (Fixes #175)
  * Updating PSToken control (more colorization) (Fixes #166)
  * YAML Formatter indent / primitive support (Fixes #180)
---

## 0.1:
* PipeScript can now Transpile Protocols (Fixes #168)
* PipeScript can transpile http[s] protocol (Fixes #169)
* PipeScript now formats the AST (Fixes #166) 
* Added .IsAssigned to CommandAST/PipelineAST (Fixes #167)
---

## 0.0.14:
* New Transpilers:
  * [RemoveParameter] (#159)
  * [RenameVariable] (#160)  
* Keyword Updates:
  * new now supports extended type creation (#164)
  * until now supports a TimeSpan, DateTime, or EventName string (#153)
* AST Extended Type Enhancements:
  * [TypeConstraintAst] and [AttributeAst] now have .ResolvedCommand (#162)
* Action Updates
  * Pulling just before push (#163)
  * Not running when there is not a current branch (#158)
  * Improving email determination (#156)
* Invoke-PipeScript terminates transpiler errors when run interactively (#161)
---

## 0.0.13:
* New / Improved Keywords 
  * assert keyword (Support for pipelines) (#143)
  * new keyword (Support for ::Create method) (#148)
  * until keyword (#146) 
* Syntax Improvements
  * Support for === (#123) (thanks @dfinke)
* New Inline PipeScript support:
  * Now Supporting Inline PipeScript in YAML (#147)
* General Improvements:
  * Extending AST Types (#145)
---

## 0.0.12:
* Adding assert keyword (#143)
* Fixing new keyword for blank constructors (#142 )
* Rest Transpiler:
  * Handling multiple QueryString values (#139)
  * Only passing ContentType to invoker if invoker supports it (#141)
  * Defaulting to JSON body when ContentType is unspecified (#140)
---

## 0.0.11:
* Source Generators Now Support Parameters / Arguments (#75)
* Invoke-PipeScript Terminating Build Errors (#135)
---

## 0.0.10:
* Improvements:
  * REST transpiler
    * Supports Query/BodyParameter with AmbientValue and DefaultBindingProperty (#119)
    * Improved Documentation
  * Logo (#132)
* Bugfixes:
  * New-PipeScript (#122)
    * Improving Improving inline documentation and [ScriptBlock] handling
  * Join-PipeScript (#124)
    * Adding .Examples
    * Fixing parameter joining issues
---

## 0.0.9:
* New Features:
  * new keyword (#128)
  * == operator (#123 (thanks @dfinke))
* Fixes
  * REST Transpiler automatically coerces [DateTime] and [switch] parameters (#118)
  * Join-PipeScript:  Fixing multiparam error (#124)
  * ValidateScriptBlock:  Only validing ScriptBlocks (#125)
---
## 0.0.8:
* New Commands:
  * New-PipeScript (#94)
  * Search-PipeScript (#115)
* New Transpilers:
  * REST (#114)
  * Inline.Kotlin (#110)
* Bugfixes and improvements:
  * Fixing Help Generation (#56)
  * Anchoring match for Get-Transpiler (#109)
  * Core Inline Transpiler Cleanup (#111)
  * Shared Context within Inline Transpilers (#112)
  * Fixing Include Transpiler Pattern (#96)
  * Join-PipeScript interactive .Substring error (#116)
---

## 0.0.7:
* Syntax Improvements:
  * Support for Dot Notation (#107)
* New Transpilers:
  * .>ModuleRelationships (#105)
  * .>ModuleExports (#104)
  * .>Aliases (#106)
* Fixes:
  * Invoke-PipeScript improved error behavior (#103)
  * Explicit Transpiler returns modified ScriptBlock (#102)
  * .psm1 alias export fix (#100)
  * Include improvements (#96)
---

## 0.0.6:
* New Transpilers:
  * ValidateScriptBlock
* Improved Transpilers:
  * [Include] not including source generators (#96)
* PipeScript.psm1 is now build with PipeScript (#95)
* Join-PipeScript:  Fixing -BlockType (#97)
* GitHub Action will now look for PipeScript.psd1 in the workspace first (#98)
---

## 0.0.5
* New Language Features:
  * PipedAssignment (#88)
* Command Fixes:
  * Invoke-PipeScript now defaults unmapped files to treating them as PowerShell / PipeScript (#86)
* Improved Transpilers:
  * .>PipeScript.Inline now supports -StartPattern/-EndPattern (#85)
  * Inline Transpilers now use -StartPattern/-EndPattern (#85)
* Inline PipeScript Support for New Languages
  * .>Inline.PSD1 (#89)
  * .>Inline.XML now handles .PS1XML (#91)
---

## 0.0.4
* New Transpilers:
  * .>RegexLiteral (#77)
* Improved Transpilers:
  * .>PipeScript.Inline now supports -ReplacePattern (#84)
  * .>Include now supports wildcards (#81)
* Inline PipeScript Support for New Languages
  * ATOM (#79)
  * Bicep (#73)
  * HLSL (#76)
  * Perl / POD (#74)
  * RSS (#80)

---
## 0.0.3
* New Transpilers:
  * .>ValidateExtension (#64)
  * .>OutputFile (#53)
* Inline PipeScript Support for New Languages
  * Python (#63)
  * PHP (#67)
  * Razor (#68)
* Bugfixes / improvements:
  * Plugged Invoke-PipeScript Parameter Leak (#69)
  * .>ValidateTypes transpiler now returns true (#65)
  * .>ValidateTypes transpiler now can apply to a [VariableExpressionAST] (#66)
* Building PipeScript with PipeScript (#54)
---

## 0.0.2
* New Transpilers:
  * .>ValidatePlatform (#58)
  * .>ValidatePropertyName (#59)
  * .>Inline.ObjectiveC (#60)
* Transpiler Fixes
  * .>VBN now supports -Position (#57)
* GitHub Action Bugfix (#55)
---
## 0.0.1
Initial Commit.
