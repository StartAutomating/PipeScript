param([Parameter(Mandatory)]$Field)
$fieldNames = 'synopsis','description','link','example','inputs', 'outputs', 'parameter', 'notes'
foreach ($block in $this.BlockComments) {                
    foreach ($match in [Regex]::new("
        \.(?<Field>$Field)                   # Field Start
        [\s-[\r\n]]{0,}                      # Optional Whitespace
        [\r\n]+                              # newline
        (?<Content>(?:.|\s)+?(?=
        (
            [\r\n]{0,}\s{0,}\.(?>$($fieldNames -join '|'))|
            \#\>|
            \z
        ))) # Anything until the next .field or end of the comment block
        ", 'IgnoreCase,IgnorePatternWhitespace', [Timespan]::FromSeconds(1)).Matches(
            $block.Value
        )) {                        
        $match.Groups["Content"].Value -replace '[\s\r\n]+$'
    }
    break
}