[ValidatePattern("docker")]
param()


function Template.Docker.StopSignal {

    <#
    .SYNOPSIS
        Template for setting the stop signal in a Dockerfile.
    .DESCRIPTION
        A Template for setting the stop signal in a Dockerfile.
    .LINK
        https://docs.docker.com/engine/reference/builder/#stopsignal
    #>
    param(
    # The signal to stop the container.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Signal
    )
    
    process {
        "STOPSIGNAL $Signal"
    }

}

