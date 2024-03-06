[ValidatePattern("(?>RSS|Language)[\s\p{P}]")]
param()

Language function RSS {
<#
.SYNOPSIS
    RSS PipeScript Language Definition.
.DESCRIPTION
    Allows PipeScript to generate RSS.

    Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.
#>
[ValidatePattern('\.rss$')]
param()
    $FilePattern = '\.rss'

    # RSS is a really simple data language (it's just XML, really)
    $DataLanguage = $true
    # RSS is case-sensitive
    $CaseSensitive = $true

    # We start off by declaring a number of regular expressions:
    $startComment = '<\!--' # * Start Comments ```<!--```
    $endComment   = '-->'   # * End Comments   ```-->```
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartPattern     ```$StartComment + '{' + $Whitespace```
    $startPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndPattern       ```$whitespace + '}' + $EndComment```
    $endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"
    
    # The "interpreter" for RSS simply reads each of the files.
    $Interpreter = {        
        $xmlFiles = @(foreach ($arg in $args) {
            if (Test-path $arg) {                
                [IO.File]::ReadAllText($arg) -as [xml]
            }
            else {
                $otherArgs += $arg
            }
        })
        
        $xmlFiles
    }
}
