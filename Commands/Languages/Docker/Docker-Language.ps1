
function Language.Docker {
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
            ## If we are in a module directory, copy the module
            # $LoadedModuleInPath = (Get-Module | Split-Path) -match ([Regex]::Escape($pwd)) | Select -first 1
            # if ($LoadedModuleInPath) { "COPY ./ ./Modules/$($LoadedModuleInPath | Split-Path -Leaf)" } 
            #}
            #{
            # param($DockerProfileScript)
            # if ($DockerProfileScript) { "COPY ./$DockerProfileScript /root/.config/powershell/Microsoft.PowerShell_profile.ps1"} 
            # }
            ENV PSModulePath ./Modules
            #{
            #if ($DockerInstallModules) { "RUN /opt/microsoft/powershell/7/pwsh --nologo -c Install-Module Splatter,ugit -Scope CurrentUser -Force"} 
            #}
        '
        $dockerFile | Set-Content .\PipeScript.Example.ps.Dockerfile
        Invoke-PipeScript .\PipeScript.Example.ps.Dockerfile
    #>
[ValidatePattern('\.?Dockerfile$')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    $LanguageName = 'Docker'
    $SingleLineCommentStart = '\#'
$startComment = "(?>(?<IsSingleLine>$SingleLineCommentStart)(?>PipeScript|PS)?\{)"
$endComment   = "(?>$SingleLineCommentStart(?:PipeScript)?\})"
$StartPattern = "(?<PSStart>${startComment})"
$EndPattern   = "(?<PSEnd>${endComment})"
$LinePattern   = "^\s{0,}$SingleLineCommentStart\s{0,}"
$ReplaceOutputFileName = ".+?Dockerfile", 'Dockerfile'
$ForeachObject = {
        
        $striginifed = "$_"
        @(
            [Environment]::NewLine 
            if ($striginifed -match '[\r\n]') {            
                    # Docker output is continued by adding a \ to the end of a line.
                $striginifed -split '[\r\n]+' -replace '\s{0,}$', "\$([Environment]::NewLine)"
            } else {
            
                "$_".Trim()
            }
        ) -replace '\\\s+' -join ''
    }
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Docker")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


