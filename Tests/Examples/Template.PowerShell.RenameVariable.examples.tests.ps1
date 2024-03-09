
describe 'Template.PowerShell.RenameVariable' {
    it 'Template.PowerShell.RenameVariable Example 1' {
        {
            [RenameVariable(VariableRename={
                @{
                    x='x1'
                    y='y1'
                }
            })]
            param($x, $y)
        } | .>PipeScript
    }
}

