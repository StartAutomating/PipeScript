
function Language.PowerShellData {
<#
.SYNOPSIS
    PSD1 Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate PSD1.
    Multiline comments blocks enclosed with {} will be treated as Blocks of PipeScript.
    Multiline comments can be preceeded or followed by single-quoted strings, which will be ignored.
    * ```''```
    * ```{}```
#>
[ValidatePattern('\.psd1$')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    $LanguageName = 'PowerShellData'
    $startComment = '<\#'
$endComment   = '\#>'
$Whitespace   = '[\s\n\r]{0,}'
$IgnoredContext = "
(?<ignore>
    (?>'((?:''|[^'])*)')
    [\s - [ \r\n ] ]{0,}
){0,1}"
$StartPattern = [regex]::New("(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)", 'IgnorePatternWhitespace')
$endPattern   = "(?<PSEnd>$Whitespace\}${endComment}[\s-[\r\n]]{0,}${IgnoredContext})"
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.PowerShellData")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


