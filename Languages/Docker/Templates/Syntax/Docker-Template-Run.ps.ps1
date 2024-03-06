[ValidatePattern("docker")]
param()

Template function Docker.Run {
    <#
    .SYNOPSIS
        Template for running a command in a Dockerfile.
    .DESCRIPTION
        A Template for running a command in a Dockerfile.
    .LINK
        https://docs.docker.com/engine/reference/builder/#run
    #>
    param(
    # The command to run.
    [vbn()]
    [string]
    $Command
    )
    
    process {
        "RUN $Command"
    }
}