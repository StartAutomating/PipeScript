Write-FormatView -TypeName Language -Property LanguageName, FilePattern

Write-FormatView -TypeName Language -Action {
    $NoteProperties = [Ordered]@{}
    foreach ($prop in $_.psobject.properties) {
        if ($prop -is [psnoteproperty]) {
            $NoteProperties[$prop.Name] = $prop.Value
        }
    }
    $NoteProperties | Format-YAML
}