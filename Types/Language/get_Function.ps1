<#
.SYNOPSIS
    Gets Language Functions
.DESCRIPTION
    Gets Functions related to a language.

    These are functions that either match a language's `.FilePattern` or start with a language name, followed by punctuation.
#>
if (-not $global:AllFunctionsAndAliases) {
    $global:AllFunctionsAndAliases = $global:ExecutionContext.SessionState.InvokeCommand.GetCommand('*','Alias,Function',$true)
}
$FunctionsForThisLanguage = [Ordered]@{PSTypeName='Language.Functions'}
if ($this.FilePattern) {    
    foreach ($FunctionForLanguage in $global:AllFunctionsAndAliases -match $this.FilePattern) {
        $FunctionsForThisLanguage["$FunctionForLanguage"] = $FunctionForLanguage
    }    
}
if ($this.LanguageName) {
    foreach ($FunctionForLanguage in $global:AllFunctionsAndAliases -match "^$([Regex]::Escape($this.LanguageName))\p{P}") {
        $FunctionsForThisLanguage["$FunctionForLanguage"] = $FunctionForLanguage
    }
}

$FunctionsForThisLanguage = [PSCustomObject]$FunctionsForThisLanguage
$FunctionsForThisLanguage.pstypenames.insert(0,"$($this.LanguageName).Functions")
$FunctionsForThisLanguage

