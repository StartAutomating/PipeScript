@{
    ModuleVersion     = '0.1.9'
    Description       = 'An Extensible Transpiler for PowerShell (and anything else)'
    RootModule        = 'PipeScript.psm1'
    PowerShellVersion = '4.0'
    AliasesToExport   = '*'
    FormatsToProcess  = 'PipeScript.format.ps1xml'
    TypesToProcess    = 'PipeScript.types.ps1xml'
    Guid              = 'fc054786-b1ce-4ed8-a90f-7cc9c27edb06'
    CompanyName       = 'Start-Automating'
    Copyright         = '2022 Start-Automating'
    Author            = 'James Brundage'
    PrivateData = @{
        PSData = @{
            ProjectURI = 'https://github.com/StartAutomating/PipeScript'
            LicenseURI = 'https://github.com/StartAutomating/PipeScript/blob/main/LICENSE'
            RecommendModule = @('PSMinifier')
            RelatedModule   = @()
            BuildModule     = @('EZOut','Piecemeal','PipeScript','HelpOut', 'PSDevOps')
            Tags            = 'PipeScript','PowerShell', 'Transpilation', 'Compiler'
            ReleaseNotes = @'
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
            
Additional history in [CHANGELOG](https://pipescript.start-automating.com/CHANGELOG)
'@
        }
    }
}
