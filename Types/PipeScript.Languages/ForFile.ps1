<#
.SYNOPSIS
    Gets the language for a file.
.DESCRIPTION
    Gets the PipeScript language definitions for a file path.
.EXAMPLE
    $PSLanguage.ForFile("a.xml")
.EXAMPLE
    $PSInterpreters.ForFile("a.js")
#>
param(
[string]
$FilePath
)

if ($FilePath -match '://') { return }

foreach ($prop in $this.psobject.properties) {
    if ($prop -is [psscriptproperty]) { continue }
    if ($prop.IsInstance -and 
        $prop.Value.LanguageName -and
        $prop.Value.FilePattern -and
        $filePath -match $prop.Value.FilePattern) {
        $prop.Value
    }
}
