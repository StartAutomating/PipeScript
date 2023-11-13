Language function Docker {
    <#
    .SYNOPSIS
        Docker language definition
    .DESCRIPTION
        Defines the Docker language within PipeScript.

        This allows the Dockerfile to be generated with PipeScript.
    .EXAMPLE
        $DockerFile = '
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
            #if ($DockerInstallModules) { "RUN /opt/microsoft/powershell/7/pwsh --noprofile --nologo -c Install-Module Splatter,ugit -Scope CurrentUser -Force"} 
            #}
        '
        $dockerFile | Set-Content .\PipeScript.Example.ps.Dockerfile
        Invoke-PipeScript .\PipeScript.Example.ps.Dockerfile
    #>
    [ValidatePattern('\.?Dockerfile$')]
    param()
    $SingleLineCommentStart = '\#'
    # Any Language can be parsed with a series of regular expresssions.
    $startComment = "(?>(?<IsSingleLine>$SingleLineCommentStart)\s{0,}(?:PipeScript)?\s{0,}\{)"
    $endComment   = "(?>$SingleLineCommentStart\s{0,}\}\s{0,}(?:PipeScript)?\s{0,})"

    # To support templates, a language has to declare `$StartPattern` and `$EndPattern`:
    $StartPattern = "(?<PSStart>${startComment})"
    $EndPattern   = "(?<PSEnd>${endComment})"

    # A language can also declare a `$LinePattern`.  If it does, any inline code that does not match this pattern will be skipped.
    # Using -LinePattern will skip any inline code not starting with #

    # Note:  Parameter blocks cannot begin on the same line as the opening brace
    $LinePattern   = "^\s{0,}$SingleLineCommentStart\s{0,}"

    # No matter what the input file was, Docker's output file must be 'Dockerfile'
    $ReplaceOutputFileName = ".+?Dockerfile", 'Dockerfile'

    $ForeachObject = {
        "$_".Trim() + [Environment]::NewLine # Each docker output should become it's own line.
    }
}
