[ValidatePattern("(?>Razor|Language)[\s\p{P}]")]
param()

Language function Razor {
<#
.SYNOPSIS
    Razor PipeScript Language Definition.    
.DESCRIPTION
    Allows PipeScript to generate Razor.

    Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.

    JavaScript/CSS comment blocks like ```/*{}*/``` will also be treated as blocks of PipeScript.

    Razor comment blocks like ```@*{}*@``` will also be treated as blocks of PipeScript.
#>
[ValidatePattern('\.(cshtml|razor)$')]
param(
)
    $FilePattern = '\.(cshtml|razor)$'

    # We start off by declaring a number of regular expressions:
    $startComment = '(?><\!--|/\*|\@\*)' 
    $endComment   = '(?>-->|\*/|\*@)'
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartPattern     ```$StartComment + '{' + $Whitespace```
    $startPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndPattern       ```$whitespace + '}' + $EndComment```
    $endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"
    
}
