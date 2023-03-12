---

title: PipeScript 0.2.3
sourceURL: https://github.com/StartAutomating/PipeScript/releases/tag/v0.2.3
tag: release
---
## PipeScript 0.2.3:

### New Features:

* Added Import-PipeScript (Fixes [#366](https://github.com/StartAutomating/PipeScript/issues/366))
  * Generating 'PipeScript.Imported' event on Import ([#371](https://github.com/StartAutomating/PipeScript/issues/371))
* Functions and Aliases can now be created in namespaces ([#329](https://github.com/StartAutomating/PipeScript/issues/329) and [#334](https://github.com/StartAutomating/PipeScript/issues/334))
  * Functions are imported as they are defined ([#360](https://github.com/StartAutomating/PipeScript/issues/360))
  * Transpilers can be defined in the PipeScript.Transpiler namespace
  * _You can now declare a transpiler and use it in the next line!_
* Partial Functions ([#369](https://github.com/StartAutomating/PipeScript/issues/369))
* Conditional Keywords ([#374](https://github.com/StartAutomating/PipeScript/issues/374)) ( You can now `break if ($false)` / `continue if ($false)`)

### Extended Type Improvements

* Vastly Extending [CommandInfo] (Making PowerShell commands much more capable)
  * Properties
    * .BlockComments (Fixes [#343](https://github.com/StartAutomating/PipeScript/issues/343))    
    * .Category (Fixes [#344](https://github.com/StartAutomating/PipeScript/issues/344))
    * .CommandNamespace (Fixes [#335](https://github.com/StartAutomating/PipeScript/issues/335))
    * .CommandMetadata ([#351](https://github.com/StartAutomating/PipeScript/issues/351))
    * .Description ([#346](https://github.com/StartAutomating/PipeScript/issues/346))  
    * .FullyQualifiedName ([#339](https://github.com/StartAutomating/PipeScript/issues/339))    
    * .Examples ([#348](https://github.com/StartAutomating/PipeScript/issues/348))
    * .Links ([#349](https://github.com/StartAutomating/PipeScript/issues/349))
    * .Metadata ([#341](https://github.com/StartAutomating/PipeScript/issues/341))
    * .Rank/Order (Fixes [#345](https://github.com/StartAutomating/PipeScript/issues/345))
    * .Synopsis ([#347](https://github.com/StartAutomating/PipeScript/issues/347))    
    * .Separator (get/set) ([#337](https://github.com/StartAutomating/PipeScript/issues/337), [#338](https://github.com/StartAutomating/PipeScript/issues/338))
  * Methods
    * .CouldPipe() ([#356](https://github.com/StartAutomating/PipeScript/issues/356))      
    * .CouldPipeType() ([#359](https://github.com/StartAutomating/PipeScript/issues/359))
    * .CouldRun ([#357](https://github.com/StartAutomating/PipeScript/issues/357))
    * .GetHelpField (Fixes [#342](https://github.com/StartAutomating/PipeScript/issues/342))
    * .IsParameterValid() ([#358](https://github.com/StartAutomating/PipeScript/issues/358))  
    * .Validate() ([#355](https://github.com/StartAutomating/PipeScript/issues/355))
* Application/ExternalScriptInfo: get/set.Root ([#340](https://github.com/StartAutomating/PipeScript/issues/340))
* .Namespace alias for non-Cmdlet CommandInfo (Fixes [#335](https://github.com/StartAutomating/PipeScript/issues/335)) 
    
### Templating Improvements

* SQL Transpiler:  Allowing Multiline Comments (Fixes [#367](https://github.com/StartAutomating/PipeScript/issues/367))
* Adding Arduino Template (Fixes [#308](https://github.com/StartAutomating/PipeScript/issues/308))
* Allowing Markdown Transpiler to Template Text (Fixes [#352](https://github.com/StartAutomating/PipeScript/issues/352))

### Command Changes

* New-PipeScript
  * Aliasing -FunctionType to -Function/CommandNamespace (Fixes [#372](https://github.com/StartAutomating/PipeScript/issues/372))
  * Transpiling content unless -NoTranspile is passed (Fixes [#370](https://github.com/StartAutomating/PipeScript/issues/370))
  * Allowing -Parameter dictionaries to contain dictionaries (Fixes [#311](https://github.com/StartAutomating/PipeScript/issues/311))
* Join-PipeScript
  * Adding -Indent (Fixes [#365](https://github.com/StartAutomating/PipeScript/issues/365))
  * Improving Unnamed end block behavior (Fixes [#363](https://github.com/StartAutomating/PipeScript/issues/363))
* Invoke-PipeScript:
  * Adding -OutputPath (Fixes [#375](https://github.com/StartAutomating/PipeScript/issues/375))

### Action Improvements

* GitHub Action Now supports -InstallModule (Fixes [#353](https://github.com/StartAutomating/PipeScript/issues/353))
* Using notices instead of set-output

### Minor Changes

* Allowing alias inheritance (Fixes [#364](https://github.com/StartAutomating/PipeScript/issues/364))
* PipeScript.FunctionDefinition: Supporting Inline Parameters (Fixes [#354](https://github.com/StartAutomating/PipeScript/issues/354))

---
            
Additional history in [CHANGELOG](https://pipescript.start-automating.com/CHANGELOG)
