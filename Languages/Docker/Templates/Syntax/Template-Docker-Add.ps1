
function Template.Docker.Add {

    <#
    .SYNOPSIS
        Template for adding files to a Docker image.
    .DESCRIPTION
        A Template for adding files to a Docker image.
    .LINK
        https://docs.docker.com/engine/reference/builder/#add        
    #>
    [Alias('Template.Docker.NewItem')]
    param(
    # The source of the file to add.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Source,
    
    # The destination of the file to add.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Destination,

    # Keep git directory
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $KeepGit,

    # Verify the checksum of the file
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Checksum,

    # Change the owner permissions
    [Alias('Chown')]
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $ChangeOwner
    )
    
    process {
        $AddOptions = @(
            if ($KeepGit) {
                "--keep-git-dir=true"
            }
            if ($Checksum) {
                "--checksum=$Checksum"            
            }
            if ($ChangeOwner) {
                "--chown=$ChangeOwner"
            }
        ) -join ' '
        "ADD $addOptions $Source $Destination" -replace '\s{2,}', ' '
    }

}

