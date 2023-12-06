<#
.SYNOPSIS
    Gets Language Templates
.DESCRIPTION
    Gets Templates related to a language.
#>
if (-not $global:AllFunctionsAndAliases) {
    $global:AllFunctionsAndAliases = $global:ExecutionContext.SessionState.InvokeCommand.GetCommand('*','Alias,Function',$true)
}
$templateCommands = $global:AllFunctionsAndAliases -match '^Template\p{P}'
$thisLanguagesTemplates = [Ordered]@{}
if ($this.FilePattern) {    
    foreach ($templateForThisLanguage in $templateCommands -match $this.FilePattern) {
        $thisLanguagesTemplates[$templateForThisLanguage -replace '^Template\p{P}' -replace $this.FilePattern] = $templateForThisLanguage
    }    
}
if ($this.LanguageName) {
    foreach ($templateForThisLanguage in $templateCommands -match $this.LanguageName) {
        $thisLanguagesTemplates[$templateForThisLanguage -replace '^Template\p{P}' -replace ([Regex]::Escape($this.LanguageName))] = $templateForThisLanguage
    }
}
$thisLanguagesTemplates

