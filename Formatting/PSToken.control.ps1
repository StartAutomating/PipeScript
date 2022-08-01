Write-FormatView -AsControl -Name "PSToken" -TypeName "n/a" -Action {
    Write-FormatViewExpression -If {
        $_.PreviousToken -and $_.Text        
    } -ScriptBlock {
        $token = $_
        $prevEnd = $_.PreviousToken.Start + $_.PreviousToken.Length
        $substring = $_.Text.Substring($prevEnd, $token.Start -  $prevEnd)
        if ($substring) { $substring} else { ''}
    }

    Write-FormatViewExpression -If {
        $_.Type -eq 'Comment'
    } -ForegroundColor Success -Property Content

    Write-FormatViewExpression -If {
        $_.Type -in 'Keyword', 'String'
    } -ForegroundColor Verbose -Property Content

    Write-FormatViewExpression -If {
        $_.Type -in 'Variable', 'Command'
    } -ForegroundColor Warning -ScriptBlock {
        $_.Content
    }

    Write-FormatViewExpression -If {
        $_.Type -in 'Operator','GroupStart', 'GroupEnd'
    } -ForegroundColor Blue -Property Content

    Write-FormatViewExpression -If {
        $_.Type -notin 'Comment', 'GroupStart', 'GroupEnd', 'Variable', 'Operator', 'Command','Keyword', 'String'
    } -Property Content
}
