Write-FormatView -TypeName Hashtable -Name Hashtable -Action {
    $_ | Format-Hashtable -Depth $FormatEnumerationLimit
}
