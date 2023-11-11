Language function Lua {
    <#
    .SYNOPSIS
        LUA Template Transpiler.
    .DESCRIPTION
        Allows PipeScript to generate LUA.

        Multiline comments like ```--{[[```  ```--}]]``` will be treated as blocks of PipeScript.    
    #>
    [ValidatePattern('\.lua$')]
    param()

    # We start off by declaring a number of regular expressions:
    $startComment = '\-\-\[\[\{' # * Start Comments ```--[[{```
    $endComment   = '--\}\]\]'   # * End Comments   ```--}]]```
    $Whitespace   = '[\s\n\r]{0,}'        
    $StartPattern = "(?<PSStart>${startComment})"    
    $EndPattern   = "(?<PSEnd>${endComment}\s{0,})"
}
