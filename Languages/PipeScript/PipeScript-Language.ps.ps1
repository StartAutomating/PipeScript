Language function PipeScript {
    <#
    .SYNOPSIS
        PipeScript Language Definition
    .DESCRIPTION
        PipeScript Language Definition for itself.

        This is primarily used as an anchor 

    #>
    param()

    # PipeScript files end in ps1.ps1 or .ps.ps1.
    $FilePattern = '\.ps(?:1?)\.ps1$'

    # PipeScript block comments are `<#` `#>`
    $StartComment = '<\#'
    $EndComment   = '\#>'
}
