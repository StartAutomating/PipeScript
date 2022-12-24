@{
    ModuleVersion     = '0.2.2'
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
    FunctionsToExport = 'Export-PipeScript','Get-PipeScript','Get-Transpiler','Invoke-PipeScript','Join-PipeScript','New-PipeScript','Search-PipeScript','Update-PipeScript','Use-PipeScript'
    PrivateData = @{
        FileTypes = @{
            Transpiler = @{
                Pattern = '\.psx\.ps1$'
                Wildcard  = '*.psx.ps1'
                Description = @'               
Transpiles an object into anything.
'@                
            }
            PipeScript = @{
                Pattern = '\.psx\.ps1{0,1}$',
                    '\.ps1{0,1}\.(?<ext>[^.]+$)',
                    '\.ps1{0,1}$'
                Description = @'
PipeScript files.
'@
                IsBuildFile = $true
            }
        }
        PSData = @{
            ProjectURI = 'https://github.com/StartAutomating/PipeScript'
            LicenseURI = 'https://github.com/StartAutomating/PipeScript/blob/main/LICENSE'
            RecommendModule = @('PSMinifier')
            RelatedModule   = @()
            BuildModule     = @('EZOut','Piecemeal','PipeScript','HelpOut', 'PSDevOps')
            Tags            = 'PipeScript','PowerShell', 'Transpilation', 'Compiler'
            ReleaseNotes = @'
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
            
Additional history in [CHANGELOG](https://pipescript.start-automating.com/CHANGELOG)
'@
        }
    }
}

