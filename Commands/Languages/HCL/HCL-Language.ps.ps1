Language function HCL {
    <#
    .SYNOPSIS
        HCL PipeScript Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate HCL (Hashicorp Commmand Language).

        Multiline comments blocks like ```/*{}*/``` will be treated as blocks of PipeScript.

        Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

        * ```null```
        * ```""```
        * ```{}```
        * ```[]```
    #>
    [ValidatePattern('\.hcl$')]
    param(
    )

    $FilePattern = '\.hcl$'
    
    # We start off by declaring a number of regular expressions:
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * IgnoredContext ```String.empty```, ```null```, blank strings and characters
    $IgnoredContext = "(?<ignore>(?>$("null", '""', "\{\}", "\[\]" -join '|'))\s{0,}){0,1}"
    
    $StartPattern = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"
    
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"

    
}