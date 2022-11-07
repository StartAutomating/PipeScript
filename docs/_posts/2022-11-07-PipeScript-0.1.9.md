---

title: PipeScript 0.1.9
sourceURL: https://github.com/StartAutomating/PipeScript/releases/tag/v0.1.9
tag: release
---
## 0.1.9:
* Protocol Transpilers
    * Adding JSONSchema transpiler (Fixes [#274](https://github.com/StartAutomating/PipeScript/issues/274))
    * HTTP Protocol: Only allowing HTTP Methods (Fixes [#275](https://github.com/StartAutomating/PipeScript/issues/275))
* Keyword improvements:
    * all scripts in $directory (Fixes [#277](https://github.com/StartAutomating/PipeScript/issues/277))
    * 'new' keyword recursively transpiles constructor arguments (Fixes [#271](https://github.com/StartAutomating/PipeScript/issues/271)) 
* Core improvements:
    * Core Transpiler stops transpilation of an item after any output (Fixes [#280](https://github.com/StartAutomating/PipeScript/issues/280))
    * [CommandAst].AsSentence now maps singleton values correctly (Fixes [#279](https://github.com/StartAutomating/PipeScript/issues/279))
    * PipeScript now handles CommandNotFound, enabling interactive use (Fixes [#281](https://github.com/StartAutomating/PipeScript/issues/281))    
            
Additional history in [CHANGELOG](https://pipescript.start-automating.com/CHANGELOG)
