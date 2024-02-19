<#
.SYNOPSIS
    Gets the language for a file.
.DESCRIPTION
    Gets the PipeScript language definitions for a path.
.EXAMPLE
    $PSLanguage.ForFile("a.xml")
.EXAMPLE
    $PSInterpreters.ForFile("a.js")
#>
param(
# The path to the file, or the name of the command.
[string]
$FilePath
)

foreach ($excludePattern in $this.ExcludePattern) {
    if ($filePath -match $excludePattern) { return }
}

foreach ($excludePath in $this.ExcludePath) {
    if (-not $excludePath) { continue } 
    if ($filePath -like $excludePath) { return }
}

foreach ($prop in $this.psobject.properties) {
    if ($prop -is [psscriptproperty]) { continue }     
    if ($prop.IsInstance -and 
        $prop.Value.LanguageName -and
        $prop.Value.FilePattern -and
        $filePath -match $prop.Value.FilePattern) {
        $prop.Value
    }
}

