[ValidatePattern("docker")]
param()


function Template.Docker.SetShell {

    <#
    .SYNOPSIS
        Template for setting the shell in a Dockerfile.
    .DESCRIPTION
        A Template for setting the shell in a Dockerfile.
    .LINK
        https://docs.docker.com/engine/reference/builder/#shell        
    #>
    [Alias('Template.Docker.Shell')]
    param(
    # The shell to set.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Shell,

    # The arguments to pass to the shell.
    [string[]]
    $Argument
    )
    
    process {
        "SHELL [`"$(@(@($Shell) + $Argument) -replace '"', '\"')  -join '", "'`"]"
    }

}

