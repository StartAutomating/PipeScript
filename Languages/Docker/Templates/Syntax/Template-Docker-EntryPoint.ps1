[ValidatePattern("docker")]
param()


function Template.Docker.EntryPoint {

    <#
    .SYNOPSIS
        Template for a Dockerfile ENTRYPOINT statement.
    .DESCRIPTION
        A Template for a Dockerfile ENTRYPOINT statement.
    .LINK
        https://docs.docker.com/engine/reference/builder/#entrypoint
    #>
    param(
    # The command to run when the container starts.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Command,

    # The arguments to pass to the command.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Arguments','Args','ArgumentList')]
    [string[]]
    $Argument
    )
    
    process {
        if ($Argument) {
            "ENTRYPOINT $Command $Argument"
        } else {
            "ENTRYPOINT $Command"
        }
        
    }

}

