
describe 'PipeScript.Automatic.Variable.IsPipedTo' {
    it 'PipeScript.Automatic.Variable.IsPipedTo Example 1' {
        & (Use-PipeScript { $IsPipedTo }) | Should -Be $False
    }
    it 'PipeScript.Automatic.Variable.IsPipedTo Example 2' {
        1 | & (Use-PipeScript { $IsPipedTo }) | Should -Be $True
    }
}

