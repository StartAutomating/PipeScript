#require -Module Piecemeal
Push-Location $PSScriptRoot

Install-Piecemeal -ExtensionNoun 'Transpiler' -ExtensionPattern '\.psx\.ps1' -ExtensionTypeName 'PipeScript.Transpiler' -OutputPath '.\Get-Transpiler.ps1'
Install-Piecemeal -ExtensionNoun 'PipeScript' -ExtensionPattern '\.psx\.ps1{0,1}$','\.ps1{0,1}\.(?<ext>[^.]+$)','\.ps1{0,1}$' -ExtensionTypeName 'PipeScript' -OutputPath '.\Get-PipeScript.ps1'


Pop-Location
