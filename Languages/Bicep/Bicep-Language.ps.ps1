[ValidatePattern("(?>Bicep|Language)")]
param()

Language function Bicep {
    <#
    .SYNOPSIS
        Bicep Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate Bicep templates.

        Multiline comments blocks like ```/*{}*/``` will be treated as blocks of PipeScript.

        Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

        * ```''```
        * ```{}```
    #>
    [ValidatePattern('\.bicep$')]
    param(
    )

    $FilePattern  = '\.bicep$'

    # We start off by declaring a number of regular expressions:
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * IgnoredContext 
    $IgnoredContext = "(?<ignore>(?>$("''", "\{\}" -join '|'))\s{0,}){0,1}"
    # * StartRegex     ```$IgnoredContext + $StartComment + '{' + $Whitespace```
    $StartPattern = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"
    # * EndRegex       ```$whitespace + '}' + $EndComment + $ignoredContext```
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"

    $compiler = @($ExecutionContext.SessionState.InvokeCommand.GetCommand('az', 'Application'))[0], "bicep", "build"
}
