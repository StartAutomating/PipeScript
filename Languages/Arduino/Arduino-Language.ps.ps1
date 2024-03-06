[ValidatePattern("(?>Arduino|Language)")]
param()

Language function Arduino {
    <#
    .SYNOPSIS
        Arduino Language Definition
    .DESCRIPTION
        Defines Arduino within PipeScript.

        This allows Arduino to be templated.

        Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

        Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

        The C++ Inline Transpiler will consider the following syntax to be empty:

        * ```null```
        * ```""```
        * ```''```
    #>
    [ValidatePattern('\.(?>ino)$')]
    param()

    $FilePattern  = '\.(?>ino)$'
    # Any Language can be parsed with a series of regular expresssions.

    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * IgnoredContext ```String.empty```, ```null```, blank strings and characters
    $IgnoredContext = "(?<ignore>(?>$("null", '""', "''" -join '|'))\s{0,}){0,1}"
    # To support templates, a language has to declare `$StartPattern` and `$EndPattern`:
    $StartPattern = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"
}