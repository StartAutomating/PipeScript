
function Template.Docker.Argument {

    <#
    .SYNOPSIS
        Template for an argument in a Dockerfile.
    .DESCRIPTION
        A Template for an argument in a Dockerfile.
    #>
    [Alias('Template.Docker.Arg')]
    param(
    # The name of the argument.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Name,
    
    # The default value of the argument.
    [Parameter(ValueFromPipelineByPropertyName)]
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
 
