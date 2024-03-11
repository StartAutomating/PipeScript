$variablePatternList = @(foreach ($serviceInfo in $this.List) {
    if ($serviceInfo.Variable) {
        [Regex]::Escape($serviceInfo.Variable)
    } elseif ($serviceInfo.VariablePattern) {
        $serviceInfo.VariablePattern
    }
})
$variablePatternRegex = [Regex]::new("(?>$($variablePatternList -join '|'))", 'IgnoreCase,IgnorePatternWhitespace','00:00:00.1')

foreach ($var in Get-Variable) {
    if ($var.Name -match $variablePatternRegex) {
        $var
    }
}