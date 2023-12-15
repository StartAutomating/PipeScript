Write-FormatView -AsControl -Name "PSToken" -TypeName "n/a" -Action {
    Write-FormatViewExpression -If {
        $_.PreviousToken -and $_.Text        
    } -ScriptBlock {
        $token = $_
        $prevEnd = $_.PreviousToken.Start + $_.PreviousToken.Length
        $substring = $_.Text.Substring($prevEnd, $token.Start -  $prevEnd)
        if ($substring) { $substring} else { '' }
    }

    Write-FormatViewExpression -If {
        $_.Type -eq 'Comment'
    } -ForegroundColor Success -Property Content

    Write-FormatViewExpression -If {
        $_.Type -in 'Keyword', 'String', 'CommandArgument'
    } -ForegroundColor Verbose -Property Content

    Write-FormatViewExpression -If {
        $_.Type -in 'Variable', 'Command'
    } -ForegroundColor Warning -Property Content

    Write-FormatViewExpression -If {
        $_.Type -in 'CommandParameter'
    } -ForegroundColor Magenta -Property Content

    Write-FormatViewExpression -If {
        $_.Type -in 'Operator','GroupStart', 'GroupEnd'
    } -ForegroundColor Magenta -Property Content

    Write-FormatViewExpression -If {
        $_.Type -notin 'Comment', 
            'Keyword', 'String', 'CommandArgument',
            'Variable', 'Command',
            'CommandParameter',
            'Operator','GroupStart', 'GroupEnd'
    } -Property Content
}
