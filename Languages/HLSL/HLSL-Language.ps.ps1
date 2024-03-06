[ValidatePattern("(?>HLSL|Language)[\s\p{P}]")]
param()

Language function HLSL {
    <#
    .SYNOPSIS
        HLSL PipeScript Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate HLSL (High Level Shader Language).

        Multiline comments with /*{}*/ will be treated as blocks of PipeScript.
    #>
    [ValidatePattern('\.(?>hlsl|effect)$')]
    param(
    )

    $FilePattern = '\.(?>hlsl|effect)$'
    
    # We start off by declaring a number of regular expressions:
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartRegex     ```$StartComment + '{' + $Whitespace```
    $StartPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndRegex       ```$whitespace + '}' + $EndComment```
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"

}