@{
    ModuleVersion     = '0.2'
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
            Where-Object Name -notmatch '\.ps1{0,1}\.ps1' |
            Foreach-Object { $_.Name.Substring(0, $_.Name.Length - $_.Extension.Length) }
        "'$($exportNames -join "','")'"
    }#>
    PrivateData = @{
        PSData = @{
            ProjectURI = 'https://github.com/StartAutomating/PipeScript'
            LicenseURI = 'https://github.com/StartAutomating/PipeScript/blob/main/LICENSE'
            RecommendModule = @('PSMinifier')
            RelatedModule   = @()
            BuildModule     = @('EZOut','Piecemeal','PipeScript','HelpOut', 'PSDevOps')
            Tags            = 'PipeScript','PowerShell', 'Transpilation', 'Compiler'
            ReleaseNotes = @'
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
            
Additional history in [CHANGELOG](https://pipescript.start-automating.com/CHANGELOG)
'@
        }
    }
}
