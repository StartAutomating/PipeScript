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

## PipeScript 0.2.5:

* Added Support for Aspects (#401)
* Support for Pre/Post commands in Core Transpiler
  * Commands Named PipeScript.PreProcess / PipeScript.Analyzer will run before transpilation of a ScriptBlock 
  * Commands Named PipeScript.PostProcess / PipeScript.Optimizer will run after transpilation of a ScriptBlock
* Adding PipeScript.Optimizer.ConsolidateAspects (Fixes #413)
* Conditional Keywords Fixes (Fixes #402)
* New-PipeScript: Improving Pipelining (Fixes #400)
* Update-PipeScript:
  * Tracing Events (#407)
  * Support for Insertions (#405, #406, #407)
* Template Improvements
  * Templates can now be either singleline or multiline (Fixes #398)
* New Language Support
  * Eiffel (#404)
  * PS1XML (#414)
  * SVG (#411)
  * XAML (#414)  
* XML Transpilers support inline xml output (Fixes #412)
* Added initial demo file (Fixes #420)

---

## PipeScript 0.2.4:

* Conditional Keywords now support throw/return (#389/#388) (also, fixed #387)
* Updating action: checking for _all_ build errors before outputting  (#378)
* Command Updates
  * New-PipeScript: Fixing Typed function creation (Fixes #372)
  * Join-PipeScript: Fixing End Block Behavior (Fixes #383)
* Templating Improvements:
  * New Languages Supported:
    * DART (#394)
    * SCALA (#395)           
  * Markdown Template Transpiler now has a more terse format (#393).
  * Markdown Template Transpiler now supports embedding in HTML comments or CSS/JavaScript comments (#113).
  * JSON/JavaScript Template: Converting Output to JSON if not [string] (#382)
  * CSS Template Template : now Outputting Objects as CSS rules (Fixes #332)
  * Core Template Transpiler is Faster (#392) and ForeachObject is improved (#390)  
* Other Improvements
  * Include transpiler: Adding -Passthru (Fixes #385) 
  * Making validation for various transpilers more careful (Fixes #381)
  * CommandNotFound behavior: Limiting recursion (Fixes #380)
  * Core Transpiler: Improving Efficiency (Fixes #379)
  * Requires allows clobbering and forces loads (Fixes #386)

---

## PipeScript 0.2.3:

### New Features:

* Added Import-PipeScript (Fixes #366)
  * Generating 'PipeScript.Imported' event on Import (#371)
* Functions and Aliases can now be created in namespaces (#329 and #334)
  * Functions are imported as they are defined (#360)
  * Transpilers can be defined in the PipeScript.Transpiler namespace
  * _You can now declare a transpiler and use it in the next line!_
* Partial Functions (#369)
* Conditional Keywords (#374) ( You can now `break if ($false)` / `continue if ($false)`)

### Extended Type Improvements

* Vastly Extending [CommandInfo] (Making PowerShell commands much more capable)
  * Properties
    * .BlockComments (Fixes #343)    
    * .Category (Fixes #344)
    * .CommandNamespace (Fixes #335)
    * .CommandMetadata (#351)
    * .Description (#346)  
    * .FullyQualifiedName (#339)    
    * .Examples (#348)
    * .Links (#349)
    * .Metadata (#341)
    * .Rank/Order (Fixes #345)
    * .Synopsis (#347)    
    * .Separator (get/set) (#337, #338)
  * Methods
    * .CouldPipe() (#356)      
    * .CouldPipeType() (#359)
    * .CouldRun (#357)
    * .GetHelpField (Fixes #342)
    * .IsParameterValid() (#358)  
    * .Validate() (#355)
* Application/ExternalScriptInfo: get/set.Root (#340)
* .Namespace alias for non-Cmdlet CommandInfo (Fixes #335) 
    
### Templating Improvements

* SQL Transpiler:  Allowing Multiline Comments (Fixes #367)
* Adding Arduino Template (Fixes #308)
* Allowing Markdown Transpiler to Template Text (Fixes #352)

### Command Changes

* New-PipeScript
  * Aliasing -FunctionType to -Function/CommandNamespace (Fixes #372)
  * Transpiling content unless -NoTranspile is passed (Fixes #370)
  * Allowing -Parameter dictionaries to contain dictionaries (Fixes #311)
* Join-PipeScript
  * Adding -Indent (Fixes #365)
  * Improving Unnamed end block behavior (Fixes #363)
* Invoke-PipeScript:
  * Adding -OutputPath (Fixes #375)

### Action Improvements

* GitHub Action Now supports -InstallModule (Fixes #353)
* Using notices instead of set-output

### Minor Changes

* Allowing alias inheritance (Fixes #364)
* PipeScript.FunctionDefinition: Supporting Inline Parameters (Fixes #354)

---

## PipeScript 0.2.2:

* Build-PipeScript is now Export-PipeScript (aliases remain) (Fixes #312)
* Export-PipeScript: Running BuildScripts first (Fixes #316)
* Join-PipeScript
  * Ensuring end blocks remain unnamed if they can be (Fixes #317)
  * Trmming empty param blocks from end (Fixes #302)
* Update-PipeScript:
  * Adding -InsertBefore/After (Fixes #309).  Improving aliasing (Fixes #310)
  * Aliasing RenameVariable to RenameParameter (Fixes #303). Improving inner docs
* requires transpiler: Caching Find-Module results (Fixes #318)
* Extending Types:
  * Adding PipeScript.Template (Fixes #315)
  * Adding 'ExtensionScript' to PipeScript.PipeScriptType (Fixes #313)
  * Greatly extending ParameterAst (Fixes #305)
  * Extending ParamBlockAst (Fixes #304)

---

## 0.2.1:

* Adding preliminary 'define' transpiler (Fixes #299)
* Improving interactive templates (now supported for all languages) (Fixes #285)
* Fixing sequence dotting within non-statements (Fixes #298)
* Allow multiple transpiler outputs to update nearby context (Fixes #297)
* No longer expanding Regex Literals in attributes (Fixes #290)

---

## 0.2:

* Massive Improvements in Templating
  * Templates can be used interactively (Fixes #285)
  * Renaming all Inline Transpilers to Template Transpilers
* Natural Parsing Improvements
  * ArrayLiterals are expanded (Fixes #291)
  * AsSentence now only allows one value into a singleton (Fixes #279)
  * Not expanding expandable strings (Fixes #286)
* Transpilers can change nearby context (Fixes #292)
* Allowing dot syntax to extend across multiple statements (Fixes #273)
* Adding requires keyword (Fixes #293)
* PipeScript modifies its own manifest (Fixes #294)

---

## 0.1.9:
* Protocol Transpilers
  * Adding JSONSchema transpiler (Fixes #274)
  * HTTP Protocol: Only allowing HTTP Methods (Fixes #275)
* Keyword improvements:
  * all scripts in $directory (Fixes #277)
  * 'new' keyword recursively transpiles constructor arguments (Fixes #271) 
* Core improvements:
  * Core Transpiler stops transpilation of an item after any output (Fixes #280)
  * [CommandAst].AsSentence now maps singleton values correctly (Fixes #279)
  * PipeScript now handles CommandNotFound, enabling interactive use (Fixes #281)
  
---

## 0.1.8:
* Improvements to 'all' keyword (#264 #263 #260 #253)
* Keywords can now be run interactively (#263)
* New keyword can be piped to (#265)
* Sentences can now map multi-word aliases (#260)
* New [CommandAST] properties: .IsPipedTo .IsPipedFrom
* Added Inline HAXE and Inline Racket support (#259 #262)

---


## 0.1.7:
* Added LATEX / TEX support (Fixes #230)
* Adding LUA support (Fixes #246)
* Fixing Core Transpiler Attribute Behavior (Fixes #247)

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
