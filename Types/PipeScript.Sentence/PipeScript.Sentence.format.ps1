Write-FormatView -TypeName PipeScript.Sentence -Action {
    
    Write-FormatViewExpression -ForegroundColor Warning -Property Keyword -If { $_.Command }
    Write-FormatViewExpression -ForegroundColor green -ScriptBlock { " <# $($_.Command) #> " } -If { $_.Command }  
    
    Write-FormatViewExpression -ScriptBlock { ' ' }
    Write-FormatViewExpression -ScriptBlock {
        @(foreach ($clause in $_.Clauses) {
            $wordNumber = -1
            $wordSkipCount = 0
            if ($clause.Name) {
                $wordSkipCount = @($clause.Name -split '\s').Count
                Format-RichText -InputObject " $($clause.Name)" -ForegroundColor Cyan -Italic
            }

            if ($clause.ParameterName) {
                 Format-RichText -InputObject " <# -$($clause.ParameterName) #>" -ForegroundColor green
            }

            foreach ($word in $clause.Words | Select-Object -Skip $wordSkipCount) {
                $wordNumber++
                if ("$word" -match '^[\$\@]') {
                    Format-RichText -InputObject "$word" -ForegroundColor Success
                } elseif ($wordSkipCount) {
                    Format-RichText -InputObject "$word"                
                } else {                    
                    Format-RichText -InputObject "$word" -ForegroundColor Magenta
                }                
            }
        }) -join ' '
    }
        
    Write-FormatViewExpression -ForegroundColor Magenta -If { $_.Arguments -and -not $_.Clauses } -ScriptBlock {
        $_.Arguments -join ' '
    }    
}
