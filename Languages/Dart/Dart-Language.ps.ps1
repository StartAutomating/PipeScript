[ValidatePattern("(?>Dart|Language)\s")]
param()

Language function Dart {
    <#
    .SYNOPSIS
        Dart Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate Dart.

        Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

        Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

        The Dart Template Transpiler will consider the following syntax to be empty:

        * ```null```
        * ```""```
        * ```''```
    #>
    [ValidatePattern('\.dart$')]
    param(
    )

    $FilePattern = '\.dart$'
    
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
    $DartApplication = $ExecutionContext.SessionState.InvokeCommand.GetCommand('dart','Application')
    $interpreter = $DartApplication, "run"
    $Compiler    = $DartApplication, "compile"
}
