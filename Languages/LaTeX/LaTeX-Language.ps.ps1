Language function LaTeX {
    <#
    .SYNOPSIS
        LaTeX PipeScript Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate Latex and Tex files.

        Multiline comments with %{}% will be treated as blocks of PipeScript.    
    #>
    [ValidatePattern('\.(?>latex|tex)$')]
    param()
    
    $FilePattern = '\.(?>latex|tex)$'

    # We start off by declaring a number of regular expressions:
    $startComment = '\%\{' # * Start Comments ```%{```
    $endComment   = '\}\%' # * End Comments   ```}%```
    $Whitespace   = '[\s\n\r]{0,}'        
    $StartPattern = "(?<PSStart>${startComment})"    
    $EndPattern   = "(?<PSEnd>${endComment}\s{0,})"
}