[ValidatePattern("(?>GLSL|Language)[\s\p{P}]")]
param()

Language function GLSL {
    <#
    .SYNOPSIS
        GLSL PipeScript Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate GLSL (OpenGL Shader Language).

        Multiline comments with /*{}*/ will be treated as blocks of PipeScript.
    #>
    [ValidatePattern('\.glsl$')]
    param(
    )

    $FilePattern = '\.glsl$'
    
    # We start off by declaring a number of regular expressions:
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartRegex     ```$StartComment + '{' + $Whitespace```
    $StartPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndRegex       ```$whitespace + '}' + $EndComment```
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"

}