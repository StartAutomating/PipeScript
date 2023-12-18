Write-FormatView -Typename YAML -Action {
    $inputObject = $_
    if ($inputObject.psobject.properties['Indent'].Value -as [int]) {
        $indentLevel = $inputObject.Indent -as [int]
        $inputCopy = [Ordered]@{}
        foreach ($prop in $inputObject.psobject.properties) {
            if ($prop.Name -eq 'indent') { continue }
            $inputCopy[$prop.Name] = $prop.Value
        }
        Format-YAML -inputObject $inputCopy -Indent $indentLevel
    } else {
        Format-YAML -inputObject $inputObject    
    }
    
}
