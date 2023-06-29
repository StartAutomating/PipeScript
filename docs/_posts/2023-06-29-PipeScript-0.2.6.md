---

title: PipeScript 0.2.6
sourceURL: https://github.com/StartAutomating/PipeScript/releases/tag/v0.2.6
tag: release
---
## PipeScript 0.2.6:

* PipeScript can now be sponsored! (please show your support) ([#488](https://github.com/StartAutomating/PipeScript/issues/488))

* PipeScript now has several formalized command types ([#452](https://github.com/StartAutomating/PipeScript/issues/452))
  * Aspects
    * DynamicParameters ([#462](https://github.com/StartAutomating/PipeScript/issues/462))
    * ModuleExtensionType ([#460](https://github.com/StartAutomating/PipeScript/issues/460))
    * ModuleExtensionPattern ([#460](https://github.com/StartAutomating/PipeScript/issues/460))
    * ModuleExtensionCommand ([#460](https://github.com/StartAutomating/PipeScript/issues/460))  
  * Automatic Variables (Fixes [#426](https://github.com/StartAutomating/PipeScript/issues/426))
    * $MySelf
    * $MyParameters
    * $MyCallstack
    * $MyCaller 
    * $MyCommandAst ([#434](https://github.com/StartAutomating/PipeScript/issues/434))
    * $IsPipedTo ([#430](https://github.com/StartAutomating/PipeScript/issues/430))
    * $IsPipedFrom ([#431](https://github.com/StartAutomating/PipeScript/issues/431))
  * PostProcessing/Optimization now applies to Functions ([#432](https://github.com/StartAutomating/PipeScript/issues/432))
    * Partial functions are now a PostProcessor ([#449](https://github.com/StartAutomating/PipeScript/issues/449))
  * Protocol Functions
     * Made HTTP, UDP, and JSON Schema Protocols into functions ([#474](https://github.com/StartAutomating/PipeScript/issues/474))
     * Added OpenAPI Protocol ([#457](https://github.com/StartAutomating/PipeScript/issues/457))
* Core Command Improvements
  * Get-PipeScript is now built with PipeScript ([#463](https://github.com/StartAutomating/PipeScript/issues/463))
  * Export-PipeScript
    * Is _much_ more transparent in GitHub Workflow ([#438](https://github.com/StartAutomating/PipeScript/issues/438))
    * Now lists all files built, time to build each, transpilers used, and PipeScript factor.
    * Auto Installs simple #requires in build files ([#491](https://github.com/StartAutomating/PipeScript/issues/491))
  * Update-PipeScript uses AST Based Offsets ([#439](https://github.com/StartAutomating/PipeScript/issues/439))
  * New-PipeScript
    * Making Description/Synopis ValueFromPipelineByPropertyName ([#453](https://github.com/StartAutomating/PipeScript/issues/453))
    * Adding -InputObject parameter.
    * Making -Parameter _much_ more open-ended ([#454](https://github.com/StartAutomating/PipeScript/issues/454))
    * Improving Reflection Support ([#467](https://github.com/StartAutomating/PipeScript/issues/467))
    * Allowing -Parameter as `[CommandInfo]`/`[CommandMetaData]` ([#477](https://github.com/StartAutomating/PipeScript/issues/477))
    * Supporting DefaultValue/ValidValue (Fixes [#473](https://github.com/StartAutomating/PipeScript/issues/473))
    * Adding -Verb/-Noun ([#468](https://github.com/StartAutomating/PipeScript/issues/468))
  * Invoke-PipeScript
    * Improving Positional Attribute Parameters (Fixes [#70](https://github.com/StartAutomating/PipeScript/issues/70))
    * Clarifying 'Transpiler Not Found' Messages ([#484](https://github.com/StartAutomating/PipeScript/issues/484))  

* Sentence Parsing Support
  * Improving Mutliword alias support ([#444](https://github.com/StartAutomating/PipeScript/issues/444))
  * Adding Clause.ParameterValues ([#445](https://github.com/StartAutomating/PipeScript/issues/445))
  * Allowing N words to be skipped ([#479](https://github.com/StartAutomating/PipeScript/issues/479))

* 'All' Improvements
  * Expanding Syntax for 'All' ([#436](https://github.com/StartAutomating/PipeScript/issues/436))
  * Compacting generating code ([#440](https://github.com/StartAutomating/PipeScript/issues/440))
  * Adding Greater Than / Less Than aliases ([#446](https://github.com/StartAutomating/PipeScript/issues/446))
  * Enabling 'should' ([#448](https://github.com/StartAutomating/PipeScript/issues/448))
  * 'all applications in $path' ([#475](https://github.com/StartAutomating/PipeScript/issues/475))  

* New Transpilers:
  * ValidValues ([#451](https://github.com/StartAutomating/PipeScript/issues/451))
  * Adding WhereMethod ([#465](https://github.com/StartAutomating/PipeScript/issues/465))
  * Adding ArrowOperator/ Lambdas ! ([#464](https://github.com/StartAutomating/PipeScript/issues/464))

* Extended Type Improvements
  * VariableExpressionAst.GetVariableType - Enabling InvokeMemberExpression ([#490](https://github.com/StartAutomating/PipeScript/issues/490))
  * CommandInfo.BlockComments - Resolving aliases ([#487](https://github.com/StartAutomating/PipeScript/issues/487))
  * CommandInfo.GetHelpField - Skipping additional script blocks (Fixes [#486](https://github.com/StartAutomating/PipeScript/issues/486))

* Minor Fixes:
  * Requires is now Quieter ([#433](https://github.com/StartAutomating/PipeScript/issues/433))
  * Appending Unmapped Locations to Alias Namespace (Fixes [#427](https://github.com/StartAutomating/PipeScript/issues/427))  
  * Fixing Examples in New-PipeScript (thanks @ninmonkey !)  
  * Namespaced Alias/Function - Not Transpiling if command found ([#455](https://github.com/StartAutomating/PipeScript/issues/455))  
  * Automatically Testing Examples (greatly expanded test coverage) ([#461](https://github.com/StartAutomating/PipeScript/issues/461))
  * Templates now report errors more accurately ([#489](https://github.com/StartAutomating/PipeScript/issues/489))
  * Inherit - Fixing Abstract/Dynamic Inheritance ([#480](https://github.com/StartAutomating/PipeScript/issues/480))
  * Include - Allowing Including URLs ([#481](https://github.com/StartAutomating/PipeScript/issues/481))
  * Partial Functions will not join their headers ([#483](https://github.com/StartAutomating/PipeScript/issues/483))
---
            
Additional history in [CHANGELOG](https://pipescript.start-automating.com/CHANGELOG)
