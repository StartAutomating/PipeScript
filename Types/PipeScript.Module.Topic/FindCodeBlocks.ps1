$codeFenceRegex = [Regex]::new(@'
(?>
    (?<FenceChar>[`\~]){3}    # Code fences start with tildas or backticks, repeated at least 3 times
(?<Language>                  # Match a specific language
PowerShell
)
[\s-[\r\n]]{0,}               # Match but do not capture initial whitespace.
(?<Code>                      # Capture the <Code> block
    (?:.|\s){0,}?             # This is anything until
    (?=\z|\k<FenceChar>{3})   # the end of the string or the same matching fence chars
)
(?>\z|\k<FenceChar>{3})
)
'@, 'IgnoreCase,IgnorePatternWhitespace,Singleline')

$codeFenceRegex.Matches($this.Content)