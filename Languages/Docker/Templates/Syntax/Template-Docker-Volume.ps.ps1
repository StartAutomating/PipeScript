[ValidatePattern("docker")]
param()

Template function Docker.Volume {
    <#
    .SYNOPSIS
        Template for creating a volume in a Dockerfile.
    .DESCRIPTION
        A Template for creating a volume in a Dockerfile.
    .LINK
        https://docs.docker.com/engine/reference/builder/#volume
    #>
    [Alias('Template.Docker.Vol')]
    param(
    # The path of the volume.
    [vbn()]
    [string]
    $Path
    )
    
    process {
        "VOLUME $Path"
    }
}