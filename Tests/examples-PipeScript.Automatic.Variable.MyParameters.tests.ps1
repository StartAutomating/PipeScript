
describe 'PipeScript.Automatic.Variable.MyParameters' {
    it 'PipeScript.Automatic.Variable.MyParameters Example 1' {
        Invoke-PipeScript -ScriptBlock {
            $MyParameters
        }
    }
}

