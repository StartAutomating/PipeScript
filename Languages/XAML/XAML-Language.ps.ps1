[ValidatePattern("(?>XAML|Language)[\s\p{P}]")]
param()

Language function XAML {
<#
.SYNOPSIS
    XAML PipeScript Language Definition.
.DESCRIPTION
    Allows PipeScript to generate XAML.

    Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.

    Executed output will be converted to XAML
#>
[ValidatePattern('\.xaml$')]
param()
    $FilePattern = '\.xaml$'
    # We start off by declaring a number of regular expressions:
    $startComment = '<\!--' # * Start Comments ```<!--```
    $endComment   = '-->'   # * End Comments   ```-->```
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartPattern     ```$StartComment + '{' + $Whitespace```
    $startPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndPattern       ```$whitespace + '}' + $EndComment```
    $endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"


}
