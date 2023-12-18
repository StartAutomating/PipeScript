<#
.SYNOPSIS
    Gets the number of loaded parsers.
.DESCRIPTION
    Gets the number of parsers loaded by PipeScript.
.EXAMPLE
    $PSParser.Count
#>
$count= 0
foreach ($prop in $this.psobject.properties) {
    if ($prop -is [psscriptproperty]) { continue }
    if ($prop.Value -is [Management.Automation.CommandInfo]) {
        $count++
    }
}
return $count