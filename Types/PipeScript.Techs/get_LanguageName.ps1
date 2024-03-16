<#
.SYNOPSIS
    Gets the loaded language names.
.DESCRIPTION
    Gets the names of language definitions loaded by PipeScript.
.EXAMPLE
    $PSLanguage.LanguageName
#>

,@(foreach ($prop in $this.psobject.properties) {
    if ($prop -is [psscriptproperty]) { continue }
    if ($prop.IsInstance -and $prop.Value.LanguageName) {
        $prop.Value.LanguageName
    }
})