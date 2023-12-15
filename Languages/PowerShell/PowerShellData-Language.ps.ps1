Language function PowerShellData {
<#
.SYNOPSIS
    PSD1 PipeScript Language Definition.
.DESCRIPTION
    Allows PipeScript to generate PSD1.

    Multiline comments blocks enclosed with {} will be treated as Blocks of PipeScript.

    Multiline comments can be preceeded or followed by single-quoted strings, which will be ignored.

    * ```''```
    * ```{}```
#>
[ValidatePattern('\.psd1$')]
param()

$FilePattern = '\.psd1$'

# We start off by declaring a number of regular expressions:
$startComment = '<\#' # * Start Comments ```\*```
$endComment   = '\#>' # * End Comments   ```/*```
$Whitespace   = '[\s\n\r]{0,}'
# * IgnoredContext (single-quoted strings)
$IgnoredContext = [Regex]::New("
(?<Ignore>
    (?>'((?:''|[^'])*)')
    [\s - [ \r\n ] ]{0,}
){0,1}",'IgnoreCase,IgnorePatternWhitespace')
# * StartPattern     ```$IgnoredContext + $StartComment + '{' + $Whitespace```
$StartPattern = [regex]::New("(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)", 'IgnorePatternWhitespace')
# * EndPattern       ```$whitespace + '}' + $EndComment + $ignoredContext```
$endPattern   = [regex]::New("(?<PSEnd>$Whitespace\}${endComment}[\s-[\r\n]]{0,}${IgnoredContext})", 'IgnorePatternWhitespace')

$IsDataLanguage = $true

$Interpreter = {
    param()
    $Psd1Path, $OtherArgs = $args
    if (Test-Path $Psd1Path) {
        Import-LocalizedData -BaseDirectory ($Psd1Path | Split-Path) -FileName ($Psd1Path | Split-Path -Leaf)
    }
    
}

}
