@{
    ModuleVersion     = '0.2.3'
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
## PipeScript 0.2.3:

### New Features:

* Added Import-PipeScript (Fixes #366)
  * Generating 'PipeScript.Imported' event on Import (#371)
* Functions and Aliases can now be created in namespaces (#329 and #334)
  * Functions are imported as they are defined (#360)
  * Transpilers can be defined in the PipeScript.Transpiler namespace
  * _You can now declare a transpiler and use it in the next line!_
* Partial Functions (#369)
* Conditional Keywords (#374) ( You can now `break if ($false)` / `continue if ($false)`)

### Extended Type Improvements

* Vastly Extending [CommandInfo] (Making PowerShell commands much more capable)
  * Properties
    * .BlockComments (Fixes #343)    
    * .Category (Fixes #344)
    * .CommandNamespace (Fixes #335)
    * .CommandMetadata (#351)
    * .Description (#346)  
    * .FullyQualifiedName (#339)    
    * .Examples (#348)
    * .Links (#349)
    * .Metadata (#341)
    * .Rank/Order (Fixes #345)
    * .Synopsis (#347)    
    * .Separator (get/set) (#337, #338)
  * Methods
    * .CouldPipe() (#356)      
    * .CouldPipeType() (#359)
    * .CouldRun (#357)
    * .GetHelpField (Fixes #342)
    * .IsParameterValid() (#358)  
    * .Validate() (#355)
* Application/ExternalScriptInfo: get/set.Root (#340)
* .Namespace alias for non-Cmdlet CommandInfo (Fixes #335) 
    
### Templating Improvements

* SQL Transpiler:  Allowing Multiline Comments (Fixes #367)
* Adding Arduino Template (Fixes #308)
* Allowing Markdown Transpiler to Template Text (Fixes #352)

### Command Changes

* New-PipeScript
  * Aliasing -FunctionType to -Function/CommandNamespace (Fixes #372)
  * Transpiling content unless -NoTranspile is passed (Fixes #370)
  * Allowing -Parameter dictionaries to contain dictionaries (Fixes #311)
* Join-PipeScript
  * Adding -Indent (Fixes #365)
  * Improving Unnamed end block behavior (Fixes #363)
* Invoke-PipeScript:
  * Adding -OutputPath (Fixes #375)

### Action Improvements

* GitHub Action Now supports -InstallModule (Fixes #353)
* Using notices instead of set-output

### Minor Changes

* Allowing alias inheritance (Fixes #364)
* PipeScript.FunctionDefinition: Supporting Inline Parameters (Fixes #354)

---
            
Additional history in [CHANGELOG](https://pipescript.start-automating.com/CHANGELOG)
'@
        }
    }
}
