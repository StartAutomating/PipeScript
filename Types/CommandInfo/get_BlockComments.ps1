if (-not $this.ScriptBlock) {
    return @()
}

@([Regex]::New("
\<\# # The opening tag
(?<Block>
    (?:.|\s)+?(?=\z|\#>) # anything until the closing tag
)
\#\> # the closing tag
", 'IgnoreCase,IgnorePatternWhitespace', '00:00:01').Matches($this.ScriptBlock)) -as [Text.RegularExpressions.Match[]]
