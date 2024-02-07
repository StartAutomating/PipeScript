Write-FormatView -TypeName Language -Property LanguageName, FilePattern

Write-FormatView -TypeName Language -Action {
    $NoteProperties = [Ordered]@{}
    foreach ($psProp in $_.psobject.properties) {
        if ($psProp -is [psnoteproperty]) {
            $NoteProperties[$psProp.Name] = $psProp.Value
        }
    }
    Format-YAML -InputObject ([PSCustomObject]$NoteProperties)
}