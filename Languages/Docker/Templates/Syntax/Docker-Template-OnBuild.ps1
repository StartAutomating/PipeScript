[ValidatePattern("docker")]
param()


function Template.Docker.OnBuild {

    <#
    .SYNOPSIS
        Template for running a command in the build of a Dockerfile.
    .DESCRIPTION
        A Template for running a command in the build of this image in a Dockerfile.
    .LINK
        https://docs.docker.com/engine/reference/builder/#onbuild
    #>
    param(
    # The command to run.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Command
    )
    
    process {
        "ONBUILD $Command"
    }

}

