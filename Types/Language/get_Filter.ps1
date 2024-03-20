<#
.SYNOPSIS
    Gets Language Filters
.DESCRIPTION
    Gets Filters related to a language.
    
    Filters are a special type of function that are used to filter or transform data.    

    These are filters that either match a language's `.FilePattern` or start with a language name, followed by punctuation.
#>
if (-not $global:AllFunctionsAndAliases) {
    $global:AllFunctionsAndAliases = $global:ExecutionContext.SessionState.InvokeCommand.GetCommand('*','Function',$true)
}
$FunctionsForThisLanguage = [Ordered]@{PSTypeName='Language.Functions'}
if ($this.FilePattern) {    
    foreach ($FunctionForLanguage in $global:AllFunctionsAndAliases -match $this.FilePattern) {
        if (-not $FunctionsForThisLanguage.IsFilter) {continue }
        $FunctionsForThisLanguage["$FunctionForLanguage"] = $FunctionForLanguage
    }    
}
if ($this.LanguageName) {
    foreach ($FunctionForLanguage in $global:AllFunctionsAndAliases -match "(?<=(?>^|[\p{P}-[\\]]))$([Regex]::Escape($this.LanguageName))[\p{P}-[\\]]") {
        if (-not $FunctionsForThisLanguage.IsFilter) {continue }
        $FunctionsForThisLanguage["$FunctionForLanguage"] = $FunctionForLanguage
    }
}

$FunctionsForThisLanguage = [PSCustomObject]$FunctionsForThisLanguage
$FunctionsForThisLanguage.pstypenames.insert(0,"$($this.LanguageName).Functions")
$FunctionsForThisLanguage

