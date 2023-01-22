---

title: PipeScript 0.2.2
sourceURL: https://github.com/StartAutomating/PipeScript/releases/tag/v0.2.2
tag: release
---
## PipeScript 0.2.2:

* Build-PipeScript is now Export-PipeScript (aliases remain) (Fixes [#312](https://github.com/StartAutomating/PipeScript/issues/312))
* Export-PipeScript: Running BuildScripts first (Fixes [#316](https://github.com/StartAutomating/PipeScript/issues/316))
* Join-PipeScript
  * Ensuring end blocks remain unnamed if they can be (Fixes [#317](https://github.com/StartAutomating/PipeScript/issues/317))
  * Trmming empty param blocks from end (Fixes [#302](https://github.com/StartAutomating/PipeScript/issues/302))
* Update-PipeScript:
  * Adding -InsertBefore/After (Fixes [#309](https://github.com/StartAutomating/PipeScript/issues/309)).  Improving aliasing (Fixes [#310](https://github.com/StartAutomating/PipeScript/issues/310))
  * Aliasing RenameVariable to RenameParameter (Fixes [#303](https://github.com/StartAutomating/PipeScript/issues/303)). Improving inner docs
* requires transpiler: Caching Find-Module results (Fixes [#318](https://github.com/StartAutomating/PipeScript/issues/318))
* Extending Types:
  * Adding PipeScript.Template (Fixes [#315](https://github.com/StartAutomating/PipeScript/issues/315))
  * Adding 'ExtensionScript' to PipeScript.PipeScriptType (Fixes [#313](https://github.com/StartAutomating/PipeScript/issues/313))
  * Greatly extending ParameterAst (Fixes [#305](https://github.com/StartAutomating/PipeScript/issues/305))
  * Extending ParamBlockAst (Fixes [#304](https://github.com/StartAutomating/PipeScript/issues/304))

---
            
Additional history in [CHANGELOG](https://pipescript.start-automating.com/CHANGELOG)
