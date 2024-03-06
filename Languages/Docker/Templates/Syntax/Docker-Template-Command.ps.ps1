[ValidatePattern("docker")]
param()

Template function Docker.Command {
    <#
    .SYNOPSIS
        Template for running a command in a Dockerfile.
    .DESCRIPTION
        The CMD instruction sets the command to be executed when running a container from an image.

        There can only be one command. If you list more than one command, only the last one will take effect.
    .LINK
        https://docs.docker.com/engine/reference/builder/#cmd
    #>
    param(
    # The command to run.
    [vbn()]
    [string]
    $Command
    )
    
    process {
        "CMD $Command"
    }
}