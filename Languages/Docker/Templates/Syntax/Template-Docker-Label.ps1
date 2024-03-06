[ValidatePattern("docker")]
param()


function Template.Docker.Label {

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
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Label,
    
    # The value of the label.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Value
    )
    
    process {
        "LABEL $Label=`"$($Value -replace '"', '\"')`""
    }

}

