Write-FormatView -TypeName Language -Property LanguageName, FilePattern

Write-FormatView -TypeName Language -Action {
    $_ | Format-YAML
}