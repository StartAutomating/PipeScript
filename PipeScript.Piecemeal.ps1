#require -Module Piecemeal

# Push to this directory
Push-Location $PSScriptRoot 
# Get-Transpiler is generated with Piecemeal
Install-Piecemeal -ExtensionNoun 'Transpiler' -ExtensionPattern '\.psx\.ps1$','^PipeScript.Transpiler' -ExtensionTypeName 'PipeScript.Transpiler' -OutputPath '.\Get-Transpiler.ps1' |
    Add-Member Noteproperty CommitMessage "Get-Transpiler: Updating Piecemeal@[$((Get-Module Piecemeal).Version)]" -Force -PassThru

# So is Get-PipeScript
Install-Piecemeal -ExtensionNoun 'PipeScript' -ExtensionPattern '\.psx\.ps1{0,1}$','\.ps1{0,1}\.(?<ext>[^.]+$)','\.ps1{0,1}$','^PipeScript.' -ExtensionTypeName 'PipeScript' -OutputPath '.\Get-PipeScript.ps1' |
    Add-Member Noteproperty CommitMessage "Get-PipeScript: Updating Piecemeal@[$((Get-Module Piecemeal).Version)]" -Force -PassThru

# Pop back to wherever we were
Pop-Location
