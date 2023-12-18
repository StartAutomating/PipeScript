
function Language.Racket {
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
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
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
    $LanguageName = 'Racket'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Racket")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


