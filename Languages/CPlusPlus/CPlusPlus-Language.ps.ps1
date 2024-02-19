Language function CPlusPlus {
    <#
    .SYNOPSIS
        C++ Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate C++, Header or Swig files.

        Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

        Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

        The within C++, PipeScript will consider the following syntax to be empty:

        * ```null```
        * ```""```
        * ```''```
    #>
    [ValidatePattern('\.(?>cpp|h|swig)$')]
    param()

    $FilePattern = '\.(?>cpp|h|swig)$'

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
    
    # The default compiler for C++ is `C++` on Windows, and `gcc` everywhere else.
    $Compiler = if ($psVersionTable.Platform -match 'win') {
        'c++'   
    } else {
        'gcc'
    }
}