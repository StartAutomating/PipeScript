@{
    ModuleVersion     = '0.0.1'
    Description       = 'An Extensible Transpiler for PowerShell (and anything else)'
    RootModule        = 'PipeScript.psm1'
    PowerShellVersion = '4.0'
    AliasesToExport   = '*'
    FormatsToProcess  = 'PipeScript.format.ps1xml'
    TypesToProcess    = 'PipeScript.types.ps1xml'
    Guid = 'fc054786-b1ce-4ed8-a90f-7cc9c27edb06'
    CompanyName='Start-Automating'
    Copyright='2022 Start-Automating'
    Author='James Brundage'
    PrivateData = @{
        PSData = @{
            ProjectURI = 'https://github.com/StartAutomating/PipeScript'
            LicenseURI = 'https://github.com/StartAutomating/PipeScript/blob/main/LICENSE'

            Tags = 'PipeScript','PowerShell', 'Transpilation', 'Compiler'
        }
    }
}