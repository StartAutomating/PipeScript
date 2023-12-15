Write-FormatView -TypeName Markdown -Action {
    $thisObject = $_
    if ($thisObject -is [string]) {        
        $thisObject        
    }
    elseif ($thisObject.Table) {
        $thisObject.Table | Format-Markdown
    }
    elseif ($thisObject.InputObject) {
        $thisObject | Format-Markdown -InputObject { $thisObject.InputObject }
    }
    elseif ($thisObject.Heading -and ($thisObject.Code -or $this.CodeLanguage)) {
        $thisObject | Format-Markdown
    }
    elseif ($thisObject.psobject.Properties.Length) {
        $thisObject | Format-Markdown
    } else {
        "$thisObject"
    }    
}
