Write-FormatView -TypeName PipeScript.Sentence -Action {
    
    Write-FormatViewExpression -ForegroundColor Verbose -Property Keyword -If { $_.Command }
    Write-FormatViewExpression -ForegroundColor Success -ScriptBlock { " <# $($_.Command) #> " } -If { $_.Command }  
    
    Write-FormatViewExpression -ScriptBlock { ' ' }
    Write-FormatViewExpression -ScriptBlock {
        @(foreach ($clause in $_.Clauses) {
            $wordNumber = -1
            foreach ($word in $clause.Words) {
                $wordNumber++
                if (-not $wordNumber) {
                    Format-RichText -ForegroundColor Warning -InputObject "$word"
                } else {
                    Format-RichText -InputObject "$word"
                }
            }
        }) -join ' '
    }
    
    Write-FormatViewExpression -ForegroundColor Magenta -If { $_.Arguments -and -not $_.Clauses } -ScriptBlock {
        $_.Arguments -join ' '
    }
}
