Language function Rust {
    <#
    .SYNOPSIS
        Rust Language Definition
    .DESCRIPTION
        Defines Rust within PipeScript.

        This allows Rust to be templated.
    #>
    [ValidatePattern('\.rs$')]
    param()

    # We start off by declaring a number of regular expressions:
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartRegex     ```$IgnoredContext + $StartComment + '{' + $Whitespace```
    $startRegex = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndRegex       ```$whitespace + '}' + $EndComment + $ignoredContext```
    $endRegex   = "(?<PSEnd>$Whitespace\}${endComment})"    
}