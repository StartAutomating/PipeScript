
describe 'Template.PowerShell.Help' {
    it 'Template.PowerShell.Help Example 1' {
    {
        [Help(Synopsis="The Synopsis", Description="A Description")]
        param()

        
        "This Script Has Help, Without Directly Writing Comments"
        
    } | .>PipeScript
    }
    it 'Template.PowerShell.Help Example 2' {
    {
        param(
        [Help(Synopsis="X Value")]
        $x
        )
    } | .>PipeScript
    }
    it 'Template.PowerShell.Help Example 3' {
    {
        param(
        [Help("X Value")]
        $x
        )
    } | .>PipeScript
    }
}

