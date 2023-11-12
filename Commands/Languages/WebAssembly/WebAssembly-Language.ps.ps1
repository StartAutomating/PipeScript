Language function WebAssembly {
<#
.SYNOPSIS
    WebAssembly Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate WebAssembly.    

    Multiline comments blocks like this ```(;{

    };)``` will be treated as blocks of PipeScript.
#>
[ValidatePattern('\.wat$')]
param()

    # We start off by declaring a number of regular expressions:
    $startComment = '\(\;' # * Start Comments ```(;```
    $endComment   = '\;\)'   # * End Comments   ```;)```
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartPattern     ```$StartComment + '{' + $Whitespace```
    $startPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndPattern       ```$whitespace + '}' + $EndComment```
    $endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"
    
}
