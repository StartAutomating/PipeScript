---

title: PipeScript 0.2.4
sourceURL: https://github.com/StartAutomating/PipeScript/releases/tag/v0.2.4
tag: release
---
## PipeScript 0.2.4:

* Conditional Keywords now support throw/return ([#389](https://github.com/StartAutomating/PipeScript/issues/389)/[#388](https://github.com/StartAutomating/PipeScript/issues/388)) (also, fixed [#387](https://github.com/StartAutomating/PipeScript/issues/387))
* Updating action: checking for _all_ build errors before outputting  ([#378](https://github.com/StartAutomating/PipeScript/issues/378))
* Command Updates
  * New-PipeScript: Fixing Typed function creation (Fixes [#372](https://github.com/StartAutomating/PipeScript/issues/372))
  * Join-PipeScript: Fixing End Block Behavior (Fixes [#383](https://github.com/StartAutomating/PipeScript/issues/383))
* Templating Improvements:
  * New Languages Supported:
    * DART ([#394](https://github.com/StartAutomating/PipeScript/issues/394))
    * SCALA ([#395](https://github.com/StartAutomating/PipeScript/issues/395))           
  * Markdown Template Transpiler now has a more terse format ([#393](https://github.com/StartAutomating/PipeScript/issues/393)).
  * Markdown Template Transpiler now supports embedding in HTML comments or CSS/JavaScript comments ([#113](https://github.com/StartAutomating/PipeScript/issues/113)).
  * JSON/JavaScript Template: Converting Output to JSON if not [string] ([#382](https://github.com/StartAutomating/PipeScript/issues/382))
  * CSS Template Template : now Outputting Objects as CSS rules (Fixes [#332](https://github.com/StartAutomating/PipeScript/issues/332))
  * Core Template Transpiler is Faster ([#392](https://github.com/StartAutomating/PipeScript/issues/392)) and ForeachObject is improved ([#390](https://github.com/StartAutomating/PipeScript/issues/390))  
* Other Improvements
  * Include transpiler: Adding -Passthru (Fixes [#385](https://github.com/StartAutomating/PipeScript/issues/385)) 
  * Making validation for various transpilers more careful (Fixes [#381](https://github.com/StartAutomating/PipeScript/issues/381))
  * CommandNotFound behavior: Limiting recursion (Fixes [#380](https://github.com/StartAutomating/PipeScript/issues/380))
  * Core Transpiler: Improving Efficiency (Fixes [#379](https://github.com/StartAutomating/PipeScript/issues/379))
  * Requires allows clobbering and forces loads (Fixes [#386](https://github.com/StartAutomating/PipeScript/issues/386))

---
            
Additional history in [CHANGELOG](https://pipescript.start-automating.com/CHANGELOG)
