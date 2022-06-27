Write-FormatView -TypeName Markdown -Action {
    $thisObject = $_
    if ($thisObject -is [string]) {        
        $thisObject        
    }
    elseif ($thisObject.Table) {
        $thisObject.Table | Format-Markdown
    }
    elseif ($thisObject.InputObject) {
        $thisObject.InputObject | Format-Markdown
    }
    elseif ($thisObject.psobject.Properties.Length) {
        $thisObject | Format-Markdown
    } else {
        "$thisObject"
    }    
}
