Template function Docker.Argument {
    <#
    .SYNOPSIS
        Template for an argument in a Dockerfile.
    .DESCRIPTION
        A Template for an argument in a Dockerfile.
    #>
    [Alias('Template.Docker.Arg')]
    param(
    # The name of the argument.
    [vbn()]
    [string]
    $Name,
    
    # The default value of the argument.
    [vbn()]
    [string]
    $DefaultValue
    )
    
    process {
        if ($DefaultValue) {
            "ARG $Name=$DefaultValue"
        } else {
            "ARG $Name"
        }        
    }
} 