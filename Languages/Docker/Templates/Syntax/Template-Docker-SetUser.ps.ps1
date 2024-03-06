[ValidatePattern("docker")]
param()

Template function Docker.SetUser {
    <#
    .SYNOPSIS
        Template for setting the current user in a Dockerfile.
    .DESCRIPTION
        A Template for setting the current user in a Dockerfile.
    .LINK
        https://docs.docker.com/engine/reference/builder/#user        
    #>
    [Alias('Template.Docker.User')]
    param(
    # The user to set.
    [vbn()]
    [string]
    $User
    )
    
    process {
        "USER $User"
    }
}