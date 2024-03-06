Template function Docker.LabelModule {
    <#
    .SYNOPSIS
        Labels a docker image from a module.
    .DESCRIPTION
        Applies labels to a docker image from module metadata.
    #>
    [Alias('Template.Docker.ModuleLabel','Template.Docker.ModuleLabels')]
    param(
    # The module to label.
    [vfp()]
    [PSModuleInfo]
    $Module
    )

    process {
        if ($this.PrivateData.PSData.ProjectURI) {
            Template.Docker.Label -Label "ProjectURI" -Value "$($this.PrivateData.PSData.ProjectURI)"
            Template.Docker.Label -Label "org.opencontainers.image.source" -Value "$($this.PrivateData.PSData.ProjectURI)"
        }

        if ($this.PrivateData.PSData.LicenseUri) {
            Template.Docker.Label -Label "LicenseURI" -Value "$($this.PrivateData.PSData.LicenseUri)"            
        }

        Template.Docker.Label -Label "Version" -Value "$($theModule.Version)"
        Template.Docker.Label -Label "Name" -Value "$($theModule.Name)"

        if ($theModule.Description) {
            Template.Docker.Label -Label "Description" -Value "$($theModule.Description)"
            Template.Docker.Label -Label "org.opencontainers.image.description" -Value "$($theModule.Description)"
        }

        if ($theModule.CompanyName) {
            Template.Docker.Label -Label "CompanyName" -Value "$($theModule.CompanyName)"
            Template.Docker.Label -Label "org.opencontainers.image.vendor" -Value "$($theModule.CompanyName)"
        }

        if ($theModule.Author) {
            Template.Docker.Label -Label "Author" -Value "$($theModule.Author)"
            Template.Docker.Label -Label "org.opencontainers.image.authors" -Value "$($theModule.Author)"
        }
    }
}