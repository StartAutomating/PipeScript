
function Template.Docker.InstallModule {

    <#
    .SYNOPSIS
        Template for installing a PowerShell module in a Dockerfile.
    .DESCRIPTION
        A Template for installing a PowerShell module in a Dockerfile.
    #>
    param(
    # The module to install.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $ModuleName,
    
    # The version of the module to install.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Version]
    $ModuleVersion
    )
    
    process {
        if ($ModuleVersion) {
            "RUN pwsh -Command Install-Module -Name '$($ModuleName -replace "'","''")' -RequiredVersion '$ModuleVersion' -Force -SkipPublisherCheck -AcceptLicense"
        } else {
            "RUN pwsh -Command Install-Module -Name '$($ModuleName -replace "'","''")' -Force -SkipPublisherCheck -AcceptLicense"
        }        
    }

}

