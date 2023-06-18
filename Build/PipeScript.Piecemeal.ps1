#require -Module Piecemeal

# Push to this directory
Push-Location ($PSScriptRoot | Split-Path)

$commandsPath = Join-Path $PWD Commands

# Get-Transpiler is generated with Piecemeal
Install-Piecemeal -ExtensionNoun 'Transpiler' -ExtensionPattern '\.psx\.ps1$','^PipeScript\p{P}Transpiler\p{P}(?!(?>format|types|tests)\p{P})','^psx\p{P}' -ExtensionTypeName 'PipeScript.Transpiler' -OutputPath (
    Join-Path $commandsPath Get-Transpiler.ps1
)

# Pop back to wherever we were
Pop-Location
