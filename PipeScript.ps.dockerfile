#{
    # <#
    # .Synopsis
    #     Sample PipeScript Dockerfile Template
    # .Description
    #     This is a working example DockerFile template that generates a dockerfile that runs PipeScript.
    # #>
    # param($BaseImage = 'mcr.microsoft.com/powershell')
    # "FROM $BaseImage"
#}

#{
    
    # param($EnvironmentVariables = [Ordered]@{PIPESCRIPT_VERSION=(Get-Module PipeScript).Version})    
    # if ($EnvironmentVariables) {
        # foreach ($kvp in $environmentVariables.GetEnumerator()) {
            # "ENV $($kvp.Key) $($kvp.Value)"
        # }
    # }
#}

#{
    # param($DockerInstallPackages = @("git","curl","ca-certificates","libc6","libgcc1") )    
    # if ($DockerInstallPackages) {"RUN apt-get update && apt-get install -y $($dockerInstallPackages -join ' ')"}
#}

ENV PSModulePath ./Modules

#{
    # param($DockerInstallModules = @("Splatter", "PSSVG", "ugit", "Irregular") )
    # $PowerShellPath = "opt/microsoft/powershell/7/pwsh"
    # if ($DockerInstallModules) { "RUN $PowerShellPath --noprofile --nologo -c Install-Module '$($DockerInstallModules -join "','")' -Scope CurrentUser -Force"}
#}

#{    
    # $LoadedModuleInPath = (Get-Module | Split-Path) -match ([Regex]::Escape($pwd)) | Select -first 1
    # if ($LoadedModuleInPath) { "COPY ./ ./Modules/$($LoadedModuleInPath | Split-Path -Leaf)" }
#}

#{
    # param(<# A Script to Run When Docker Starts #>$DockerProfileScript = "./Http.Server.Start.ps1")
    # if ($DockerProfileScript) { "COPY ./$DockerProfileScript /root/.config/powershell/Microsoft.PowerShell_profile.ps1"} 
#}

