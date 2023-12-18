Language function Scala {
<#
.SYNOPSIS
    Scala PipeScript Language Definition.
.DESCRIPTION
    Allows PipeScript to generate Scala.

    Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

    Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

    The Scala Template Transpiler will consider the following syntax to be empty:

    * ```null```
    * ```""```
    * ```''```
#>
[ValidatePattern('\.(?>scala|sc)$')]
param()
    $FilePattern = '\.(?>scala|sc)$'
    # We start off by declaring a number of regular expressions:
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * IgnoredContext ```String.empty```, ```null```, blank strings and characters
    $IgnoredContext = "(?<ignore>(?>$("null", '""', "''" -join '|'))\s{0,}){0,1}"
    # * StartPattern     ```$IgnoredContext + $StartComment + '{' + $Whitespace```
    $startPattern = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"
    # * EndPattern       ```$whitespace + '}' + $EndComment + $ignoredContext```
    $endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"   
}