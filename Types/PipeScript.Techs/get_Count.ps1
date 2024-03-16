<#
.SYNOPSIS
    Gets the number of loaded languages.
.DESCRIPTION
    Gets the number of language definitions loaded by PipeScript.
.EXAMPLE
    $PSLanguage.Count
#>
$count= 0
foreach ($prop in $this.psobject.properties) {
    if ($prop -is [psscriptproperty]) { continue }
    if ($prop.IsInstance -and $prop.Value.LanguageName) {
        $count++
    }
}
return $count