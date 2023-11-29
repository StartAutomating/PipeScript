Language function Racket {
<#
.SYNOPSIS
    Racket PipeScript Language Definition.
.DESCRIPTION
    Allows PipeScript to generate Racket.

    Multiline comments blocks enclosed with {} will be treated as Blocks of PipeScript.

    Multiline comments can be preceeded or followed by single-quoted strings, which will be ignored.

    * ```''```
    * ```{}```
#>
[ValidatePattern('\.rkt$')]
param()
    $FilePattern = '\.rkt$'

    # We start off by declaring a number of regular expressions:
    $startComment = '\#\|' # * Start Comments ```#|```
    $endComment   = '\|\#' # * End Comments   ```|#```
    $Whitespace   = '[\s\n\r]{0,}'
    # * IgnoredContext (single-quoted strings)    
    # * StartPattern     ```$IgnoredContext + $StartComment + '{' + $Whitespace```
    $startPattern = [Regex]::New("(?<PSStart>${startComment}\{$Whitespace)", 'IgnorePatternWhitespace')
    # * EndPattern       ```$whitespace + '}' + $EndComment + $ignoredContext```
    $endPattern   = "(?<PSEnd>$Whitespace\}${endComment}[\s-[\r\n]]{0,})"


}
