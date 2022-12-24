@{
    ModuleVersion     = '0.2.1'
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
    FunctionsToExport = 'Build-PipeScript','Export-PipeScript','Get-PipeScript','Get-Transpiler','Invoke-PipeScript','Join-PipeScript','New-PipeScript','Search-PipeScript','Split-PipeScript','Update-PipeScript','Use-PipeScript'
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
## 0.2.1:

* Adding preliminary 'define' transpiler (Fixes #299)
* Improving interactive templates (now supported for all languages) (Fixes #285)
* Fixing sequence dotting within non-statements (Fixes #298)
* Allow multiple transpiler outputs to update nearby context (Fixes #297)
* No longer expanding Regex Literals in attributes (Fixes #290)

---
            
Additional history in [CHANGELOG](https://pipescript.start-automating.com/CHANGELOG)
'@
        }
    }
}

