Template function Docker.From {
    <#
    .SYNOPSIS
        Template for a Dockerfile FROM statement.
    .DESCRIPTION
        A Template for a Dockerfile FROM statement.
    .LINK
        https://docs.docker.com/engine/reference/builder/#from
    #>
    param(
    # The base image to use.  By default, mcr.microsoft.com/powershell.
    [vbn()]
    [string]
    $BaseImage = 'mcr.microsoft.com/powershell'
    )
    
    process {
        "FROM $BaseImage"
    }
}
