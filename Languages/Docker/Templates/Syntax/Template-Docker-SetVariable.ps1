[ValidatePattern("docker")]
param()


function Template.Docker.SetVariable {

    <#
    .SYNOPSIS
        Template for setting a variable in a Dockerfile.
    .DESCRIPTION
        A Template for setting a variable in a Dockerfile.
    .LINK
        https://docs.docker.com/engine/reference/builder/#env        
    #>
    [Alias('Template.Docker.SetEnvironmentVariable','Template.Docker.SetEnvironment','Template.Docker.Env')]
    param(
    # The name of the variable to set.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Name,
    
    # The value to set the variable to.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Value
    )
    
    process {
        "ENV $VariableName $VariableValue"
    }

}

