[ValidatePattern("(?>Vue|Language)[\s\p{P}]")]
param()

Language function Vue {
<#
.SYNOPSIS
    Vue PipeScript Language Definition.
.DESCRIPTION
    Allows PipeScript to generate Vue files.

    Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.

    JavaScript/CSS comment blocks like ```/*{}*/``` will also be treated as blocks of PipeScript.
#>
[ValidatePattern('\.vue$')]
param(
)
    $FilePattern = '\.vue$'

    # We start off by declaring a number of regular expressions:
    $startComment = '(?><\!--|/\*)' # * Start Comments ```<!--```
    $endComment   = '(?>-->|\*/)'   # * End Comments   ```-->```
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartRegex     ```$StartComment + '{' + $Whitespace```
    $StartPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndRegex       ```$whitespace + '}' + $EndComment```
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"

}