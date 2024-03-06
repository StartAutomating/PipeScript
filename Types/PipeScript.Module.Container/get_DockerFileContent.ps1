<#
.SYNOPSIS
    Gets the content of a module's Dockerfile
.DESCRIPTION
    A module may define a .Container(s) section in its manifest. 
    
    This section may be docker file content.
    
    It can also be a hashtable containing a .DockerFile property
    (this can be the module-relative path to the .Dockerfile, or it's contents)

    If neither of these is present, a default docker file will be generated for this module.
#>
if ($this -is [string]) {
    return $this
}

if ($this.Dockerfile) {
    if (@($this.Dockerfile -split '[\r\n]+').Length -gt 1) {
        return $this.Dockerfile
    }

    $dockerFilePath = (Join-Path $this.Module $this.Dockerfile)
    if (Test-Path $dockerFilePath) {
        return (Get-Content -Raw $dockerFilePath)
    }        
}

if ($this.Module) {
    $theModule = $this.Module
    return @(
        Template.Docker.From -BaseImage "mcr.microsoft.com/powershell:latest"    
        Template.Docker.SetVariable -Name PSModulePath -Value ./Modules
        Template.Docker.CopyItem -Source "." -Destination "/Modules/$($theModule.Name)"
        if ($theModule.RequiredModules) {
            foreach ($requiredModule in $theModule.RequiredModules) {
                Template.Docker.InstallModule -ModuleName $requiredModule.Name -ModuleVersion $requiredModule.Version
            }
        }
        
        Template.Docker.LabelModule -Module $theModule

        Template.Docker.Label -label "org.opencontainers.image.created" -Value "$([DateTime]::Now.ToString('o'))"

    ) -join [Environment]::NewLine
}
