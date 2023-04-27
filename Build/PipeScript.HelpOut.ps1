#require -Module HelpOut
Push-Location ($PSScriptRoot | Split-Path)

$PipeScriptLoaded = Get-Module PipeScript
if (-not $PipeScriptLoaded) {
    $PipeScriptLoaded = Get-ChildItem -Recurse -Filter "*.psd1" | Where-Object Name -like 'PipeScript*' | Import-Module -Name { $_.FullName } -Force -PassThru
}
if ($PipeScriptLoaded) {
    "::notice title=ModuleLoaded::PipeScript Loaded" | Out-Host
} else {
    "::error:: PipeScript not loaded" |Out-Host
}

Save-MarkdownHelp -Module PipeScript -SkipCommandType Alias -PassThru -Command (Get-Transpiler) -ReplaceCommandName '\.psx\.ps1$'

Pop-Location