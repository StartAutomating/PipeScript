Write-FormatView -TypeName PipeScript.Module.Services -Action {
    Write-FormatViewExpression -ScriptBlock {
        Show-Markdown -InputObject $_.'README.md'
    }

    Write-FormatViewExpression -If { $_.Commands } -ScriptBlock {
        "Commands:" + 
        [Environment]::NewLine + 
        ("* ") + (
            $_.Commands -join ([Environment]::NewLine + ("* "))
        ) + ([Environment]::NewLine * 2)
    } -ForegroundColor Cyan

    Write-FormatViewExpression -If { $_.Commands } -ScriptBlock {
        "Types:" + 
        [Environment]::NewLine + 
        ("* ") + (
            $_.Type -join ([Environment]::NewLine + ("* "))
        ) + ([Environment]::NewLine * 2)
    } -ForegroundColor Green    
    
    Write-FormatViewExpression -If { $_.Variable } -ScriptBlock {
        "Variable:" + 
        [Environment]::NewLine + 
        ("* ") + (
            $_.Variable -join ([Environment]::NewLine + ("* "))
        ) + ([Environment]::NewLine * 2)
    } -ForegroundColor Blue
}