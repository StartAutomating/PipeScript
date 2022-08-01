$text = $this.Extent.ToString()
    
$previousToken = $null
$tokenCount = 0
@(foreach ($token in [Management.Automation.PSParser]::Tokenize($text, [ref]$null)) {
    Add-Member NoteProperty Text $text -Force -InputObject $token
    Add-Member NoteProperty PreviousToken $previousToken -Force -InputObject $token
    if ($token.Type -in 'Variable', 'String') {
        $realContent = $text.Substring($token.Start, $token.Length)
        Add-Member NoteProperty Content $realContent  -Force -InputObject $token
    }
    $previousToken = $token
    $tokenCount++
    $token            
})