<#
.SYNOPSIS
    Gets Language Templates
.DESCRIPTION
    Gets Templates related to a language.
#>
if (-not $global:AllFunctionsAndAliases) {
    $global:AllFunctionsAndAliases = $global:ExecutionContext.SessionState.InvokeCommand.GetCommand('*','Alias,Function',$true)
}
$templatePrefix   = '^Template\p{P}'
$templateCommands = $global:AllFunctionsAndAliases -match $templatePrefix
$thisLanguagesTemplates = [Ordered]@{PSTypename='Language.Templates'}
if ($this.FilePattern) {    
    foreach ($templateForThisLanguage in $templateCommands -match $this.FilePattern) {
        $thisLanguagesTemplates["$templateForThisLanguage" -replace $templatePrefix] = $templateForThisLanguage
    }    
}
if ($this.LanguageName) {
    foreach ($templateForThisLanguage in $templateCommands -match "(?<=(?>^|[\p{P}-[\\]]))$([Regex]::Escape($this.LanguageName))[\p{P}-[\\]]") {
        $thisLanguagesTemplates["$templateForThisLanguage" -replace $templatePrefix] = $templateForThisLanguage
    }
}
$thisLanguagesTemplates = [PSCustomObject]$thisLanguagesTemplates
$thisLanguagesTemplates.pstypenames.insert(0, "$($this.LanguageName).Templates")
$thisLanguagesTemplates

