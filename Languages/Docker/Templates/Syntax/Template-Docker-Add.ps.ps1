[ValidatePattern("docker")]
param()

Template function Docker.Add {
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
    [vbn()]
    [string]
    $Source,
    
    # The destination of the file to add.
    [vbn()]
    [string]
    $Destination,

    # Keep git directory
    [vbn()]
    [switch]
    $KeepGit,

    # Verify the checksum of the file
    [vbn()]
    [string]
    $Checksum,

    # Change the owner permissions
    [Alias('Chown')]
    [vbn()]
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