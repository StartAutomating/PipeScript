Language function Wren {
    <#
    .SYNOPSIS
        Wren PipeScript Language Definition
    .DESCRIPTION
        Allows PipeScript to generate and interpret [Wren](https://wren.io/)
    #>
    param()

    $FilePattern = '\.wren$'

    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    
    # * StartPattern     ```$StartComment + '{' + $Whitespace```
    $startPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndPattern       ```$whitespace + '}' + $EndComment + $ignoredContext```
    $endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"

    $CaseSentitive = $true

    $Interpreter   = 'wren_cli'
}
