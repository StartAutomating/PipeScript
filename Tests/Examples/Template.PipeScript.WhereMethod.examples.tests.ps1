
describe 'Template.PipeScript.WhereMethod' {
    it 'Template.PipeScript.WhereMethod Example 1' {
        { Get-PipeScript | ? CouldPipeType([ScriptBlock]) } | Use-PipeScript
    }
}

