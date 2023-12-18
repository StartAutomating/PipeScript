

$regexPatterns = @(foreach ($attr in $this.ScriptBlock.Attributes) {
    if ($attr -isnot [ValidatePattern]) { continue }
    [Regex]::new($attr.RegexPattern, $attr.Options, '00:00:05')
})

foreach ($arg in $args) {
    foreach ($regexPattern in $regexPatterns) {
       if ($regexPattern.IsMatch($arg)) { return $true }
    }
}

return $false