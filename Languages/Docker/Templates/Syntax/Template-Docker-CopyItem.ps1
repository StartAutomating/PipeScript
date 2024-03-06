
function Template.Docker.CopyItem {

    <#
    .SYNOPSIS
        Template for copying an item in a Dockerfile.
    .DESCRIPTION
        A Template for copying an item in a Dockerfile.
    .LINK
        https://docs.docker.com/engine/reference/builder/#copy
    #>
    [Alias('Template.Docker.Copy')]
    param(
    # The source item to copy.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('SourcePath','SourceItem')]
    [string]
    $Source,
    
    # The destination to copy the item to.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Destination
    )
    
    process {
        "COPY $Source $Destination"
    }

}

