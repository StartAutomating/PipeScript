<#
.SYNOPSIS
    Gets the loaded interpreter names.
.DESCRIPTION
    Gets the names of languages within PipeScript that define an `.Interpreter`.
.EXAMPLE
    $PSLanguage.LanguageName
#>

,@(foreach ($prop in $this.psobject.properties) {
    if ($prop -is [psscriptproperty]) { continue }
    if ($prop.IsInstance -and $prop.Value.LanguageName) {
        $prop.Value.LanguageName
    }
})