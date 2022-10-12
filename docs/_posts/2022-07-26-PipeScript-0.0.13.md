---

title: PipeScript 0.0.13
sourceURL: https://github.com/StartAutomating/PipeScript/releases/tag/v0.0.13
tag: release
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
