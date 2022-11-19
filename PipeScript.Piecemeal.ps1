#require -Module Piecemeal

# Push to this directory
Push-Location $PSScriptRoot 
# Get-Transpiler is generated with Piecemeal
Install-Piecemeal -ExtensionNoun 'Transpiler' -ExtensionPattern '\.psx\.ps1$' -ExtensionTypeName 'PipeScript.Transpiler' -OutputPath '.\Get-Transpiler.ps1' |
    Add-Member Noteproperty CommitMessage "Get-Transpiler: Updating Piecemeal Version" -Force -PassThru

# So is Get-PipeScript
Install-Piecemeal -ExtensionNoun 'PipeScript' -ExtensionPattern '\.psx\.ps1{0,1}$','\.ps1{0,1}\.(?<ext>[^.]+$)','\.ps1{0,1}$' -ExtensionTypeName 'PipeScript' -OutputPath '.\Get-PipeScript.ps1' |
    Add-Member Noteproperty CommitMessage "Get-PipeScript: Updating Piecemeal Version" -Force -PassThru

# Pop back to wherever we were
Pop-Location
