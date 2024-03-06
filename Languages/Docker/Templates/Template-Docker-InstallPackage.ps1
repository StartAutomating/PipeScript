
function Template.Docker.InstallPackage {

    <#
    .SYNOPSIS
        Template for installing a package in a Dockerfile.
    .DESCRIPTION
        A Template for installing a package in a Dockerfile.
    #>
    param(
    # The package to install.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $PackageName
    )
    
    process {
        "RUN apt-get update && apt-get install -y $($PackageName -join ' ')"
    }

}

