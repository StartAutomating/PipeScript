[ValidatePattern("(?>FSharp|F\#|Language)[\s\p{P}]")]
param()

Language function FSharp {
    <#
    .SYNOPSIS
        FSharp PipeScript Language Definition
    .DESCRIPTION
        Allows PipeScript to Generate FSharp        
    #>
    param()

    # FSharp Files are named `.fs`,`.fsi`,`.fsx`, or `.fsscript`.
    $FilePattern = '\.fs(?>i|x|script|)$'

    # FSharp Block Comments Start with `(*`
    $startComment = '\(\*'
    # FSharp Block Comments End with  `*)'
    $endComment   = '\*\)'
    
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartRegex     ```$StartComment + '{' + $Whitespace```
    $StartPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndRegex       ```$whitespace + '}' + $EndComment```
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"

    $CaseSensitive = $true
}
