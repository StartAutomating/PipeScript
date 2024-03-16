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
    return if $filePath -match $excludePattern
}

foreach ($excludePath in $this.ExcludePath) {
    continue if -not $excludePath
    return if $filePath -like $excludePath
}

foreach ($prop in $this.psobject.properties) {
    continue if $prop -is [psscriptproperty]    
    if ($prop.IsInstance -and 
        $prop.Value.LanguageName -and
        $prop.Value.FilePattern -and
        $filePath -match $prop.Value.FilePattern) {
        $prop.Value
    }
}
