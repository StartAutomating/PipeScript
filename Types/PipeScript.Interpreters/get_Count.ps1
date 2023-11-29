<#
.SYNOPSIS
    Gets the number of loaded interpreters.
.DESCRIPTION
    Gets the number of PipeScript language definitions that have an interpeter.
.EXAMPLE
    $PSInterpreter.Count
#>
$count= 0
foreach ($prop in $this.psobject.properties) {
    if ($prop -is [psscriptproperty]) { continue }
    if ($prop.IsInstance -and $prop.Value.LanguageName) {
        $count++
    }
}
return $count