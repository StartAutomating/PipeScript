@{
    ModuleVersion     = '0.2.5'
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
    FunctionsToExport = 'Export-Pipescript','Get-PipeScript','Get-Transpiler','Import-PipeScript','Invoke-PipeScript','Join-PipeScript','New-PipeScript','Search-PipeScript','Update-PipeScript','Use-PipeScript','PipeScript.Optimizer.ConsolidateAspects','PipeScript.PostProcess.InitializeAutomaticVariables','PipeScript.PostProcess.PartialFunction','PipeScript.Automatic.Variable.IsPipedTo','PipeScript.Automatic.Variable.IsPipedFrom','PipeScript.Automatic.Variable.MyCallstack','PipeScript.Automatic.Variable.MySelf','PipeScript.Automatic.Variable.MyParameters','PipeScript.Automatic.Variable.MyCaller','PipeScript.Automatic.Variable.MyCommandAst'
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
## PipeScript 0.2.5:

* Added Support for Aspects (#401)
* Support for Pre/Post commands in Core Transpiler
  * Commands Named PipeScript.PreProcess / PipeScript.Analyzer will run before transpilation of a ScriptBlock 
  * Commands Named PipeScript.PostProcess / PipeScript.Optimizer will run after transpilation of a ScriptBlock
* Adding PipeScript.Optimizer.ConsolidateAspects (Fixes #413)
* Conditional Keywords Fixes (Fixes #402)
* New-PipeScript: Improving Pipelining (Fixes #400)
* Update-PipeScript:
  * Tracing Events (#407)
  * Support for Insertions (#405, #406, #407)
* Template Improvements
  * Templates can now be either singleline or multiline (Fixes #398)
* New Language Support
  * Eiffel (#404)
  * PS1XML (#414)
  * SVG (#411)
  * XAML (#414)  
* XML Transpilers support inline xml output (Fixes #412)
* Added initial demo file (Fixes #420)

---
            
Additional history in [CHANGELOG](https://pipescript.start-automating.com/CHANGELOG)
'@
        }
    }
}

