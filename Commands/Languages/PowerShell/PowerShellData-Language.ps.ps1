Language function PowerShellData {
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
param()


# We start off by declaring a number of regular expressions:
$startComment = '<\#' # * Start Comments ```\*```
$endComment   = '\#>' # * End Comments   ```/*```
$Whitespace   = '[\s\n\r]{0,}'
# * IgnoredContext (single-quoted strings)
$IgnoredContext = "
(?<ignore>
    (?>'((?:''|[^'])*)')
    [\s - [ \r\n ] ]{0,}
){0,1}"
# * StartPattern     ```$IgnoredContext + $StartComment + '{' + $Whitespace```
$StartPattern = [regex]::New("(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)", 'IgnorePatternWhitespace')
# * EndPattern       ```$whitespace + '}' + $EndComment + $ignoredContext```
$endPattern   = "(?<PSEnd>$Whitespace\}${endComment}[\s-[\r\n]]{0,}${IgnoredContext})"

}