[ValidatePattern("docker")]
param()

Template function Docker.Label {
    <#
    .SYNOPSIS
        Template for setting a label in a Dockerfile.
    .DESCRIPTION
        A Template for setting a label in a Dockerfile.
    .LINK
        https://docs.docker.com/engine/reference/builder/#label
    #>
    param(
    # The label to set.
    [vbn()]
    [string]
    $Label,
    
    # The value of the label.
    [vbn()]
    [string]
    $Value
    )
    
    process {
        "LABEL $Label=`"$($Value -replace '"', '\"')`""
    }
}