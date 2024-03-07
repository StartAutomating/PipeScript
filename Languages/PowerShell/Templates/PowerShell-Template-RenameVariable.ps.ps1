Template function PowerShell.RenameVariable {
    <#
    .SYNOPSIS
        Renames variables
    .DESCRIPTION
        Renames variables in a ScriptBlock
    .EXAMPLE
        {
            [RenameVariable(VariableRename={
                @{
                    x='x1'
                    y='y1'
                }
            })]
            param($x, $y)
        } | .>PipeScript
    .LINK
        Update-PipeScript
    #>
    param(
    # The name of one or more parameters to remove
    [Parameter(Mandatory,Position=0)]
    [Alias('Variables','RenameVariables', 'RenameVariable','VariableRenames')]
    [Collections.IDictionary]
    $VariableRename,

    # The ScriptBlock that declares the parameters.
    [Parameter(Mandatory,ValueFromPipeline)]
    [scriptblock]
    $ScriptBlock
    )

    process {
        Update-PipeScript -ScriptBlock $ScriptBlock -RenameVariable $VariableRename
    }
}