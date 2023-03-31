@{
    ModuleVersion     = '0.2.4'
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
    FunctionsToExport = '' <#{
        $exportNames = Get-ChildItem -Recurse -Filter '*-*.ps1' |
            Where-Object Name -notmatch '\.[^\.]+\.ps1' |
            Foreach-Object { $_.Name.Substring(0, $_.Name.Length - $_.Extension.Length) }
        "'$($exportNames -join "','")'"
    }#>
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
            
Additional history in [CHANGELOG](https://pipescript.start-automating.com/CHANGELOG)
'@
        }
    }
}
