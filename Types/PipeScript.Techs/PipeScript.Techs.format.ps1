
Write-FormatView -TypeName "PipeScript.Languages" -Action {
    if ($ExecutionContext.SessionState.InvokeCommand.GetCommand('Show-Markdown', 'Cmdlet')) {
        Show-Markdown -InputObject $_.'README'
    } else {
        $_.'README'
    }   
}