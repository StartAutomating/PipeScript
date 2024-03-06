[ValidatePattern("docker")]
param()

Template function Docker.SetLocation {
    <#
    .SYNOPSIS
        Template for setting the working directory in a Dockerfile.
    .DESCRIPTION
        A Template for setting the working directory in a Dockerfile.
    .LINK
        https://docs.docker.com/engine/reference/builder/#workdir
    #>
    [Alias('Template.Docker.WorkDir','Template.Docker.CD')]
    param(
    # The path to set as the working directory.
    [vbn()]
    [string]
    $Path
    )
    
    process {
        "WORKDIR $Path"
    }
}