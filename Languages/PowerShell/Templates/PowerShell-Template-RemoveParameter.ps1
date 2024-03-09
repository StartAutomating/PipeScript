[ValidatePattern('PowerShell')]
param()


function Template.PowerShell.RemoveParameter {

    <#
    .SYNOPSIS
        Removes Parameters from a ScriptBlock
    .DESCRIPTION
        Removes Parameters from a ScriptBlock
    .EXAMPLE
        {
            [RemoveParameter("x")]
            param($x, $y)
        } | .>PipeScript
    .LINK
        Update-PipeScript
    #>
    param(
    # The name of one or more parameters to remove
    [Parameter(Mandatory,Position=0)]
    [string[]]
    $ParameterName,

    # The ScriptBlock that declares the parameters.
    [Parameter(Mandatory,ValueFromPipeline)]
    [scriptblock]
    $ScriptBlock
    )

    process {
        Update-PipeScript -ScriptBlock $ScriptBlock -RemoveParameter $ParameterName
    }


}

