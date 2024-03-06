[ValidatePattern("(?>C3|Language)\s")]
param()

Language function C3 {
    <#
    .SYNOPSIS
        PipeScript C3 Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate C3 files.

        Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

        Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

        The C3 will consider the following syntax to be empty:

        * ```null```
        * ```""```
        * ```''```
    #>
    [ValidatePattern('\.c3$')]
    param(
    )

    $FilePattern = '\.c3$'
    $Compiler = 'c3c'
    $ProjectURL = 'https://github.com/c3lang/c3c'

    # We start off by declaring a number of regular expressions:
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * IgnoredContext ```String.empty```, ```null```, blank strings and characters
    $IgnoredContext = "(?<ignore>(?>$("null", '""', "''" -join '|'))\s{0,}){0,1}"
    # * StartRegex     ```$IgnoredContext + $StartComment + '{' + $Whitespace```
    $StartPattern = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"
    # * EndRegex       ```$whitespace + '}' + $EndComment + $ignoredContext```
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"
}