
function Language.Racket {
<#
.SYNOPSIS
    Racket Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate Racket.
    Multiline comments blocks enclosed with {} will be treated as Blocks of PipeScript.
    Multiline comments can be preceeded or followed by single-quoted strings, which will be ignored.
    * ```''```
    * ```{}```
#>
[ValidatePattern('\.rkt$')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    $LanguageName = 'Racket'
    $startComment = '\#\|'
$endComment   = '\|\#'
$Whitespace   = '[\s\n\r]{0,}'
$startPattern = [Regex]::New("(?<PSStart>${startComment}\{$Whitespace)", 'IgnorePatternWhitespace')
$endPattern   = "(?<PSEnd>$Whitespace\}${endComment}[\s-[\r\n]]{0,})"
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Racket")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


