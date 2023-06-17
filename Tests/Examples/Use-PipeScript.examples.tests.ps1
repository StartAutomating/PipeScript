
describe 'Use-PipeScript' {
    it 'Use-PipeScript Example 1' {
        { "Hello World" } | .>PipeScript # Returns an unchanged ScriptBlock, because there was nothing to run.
    }
}

