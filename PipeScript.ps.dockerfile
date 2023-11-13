    FROM mcr.microsoft.com/powershell


    #{

    ## If we're in a module directory, copy the module

    # $LoadedModuleInPath = (Get-Module | Split-Path) -match ([Regex]::Escape($pwd)) | Select -first 1
    # if ($LoadedModuleInPath) { "COPY ./ ./Modules/$($LoadedModuleInPath | Split-Path -Leaf)" } 

    #}

    #{
    # param($DockerProfileScript)
    # if ($DockerProfileScript) { "COPY ./$DockerProfileScript /root/.config/powershell/Microsoft.PowerShell_profile.ps1"} 
    # }
    ENV PSModulePath ./Modules

    #{
    #if ($DockerInstallModules) { "RUN /opt/microsoft/powershell/7/pwsh --noprofile --nologo -c Install-Module '$($DockerInstallModules -join "','")'' -Scope CurrentUser -Force"} 
    #}


