
describe 'PipeScript.Automatic.Variable.IsPipedFrom' {
    it 'PipeScript.Automatic.Variable.IsPipedFrom Example 1' {
        $PipedFrom = & (Use-PipeScript { $IsPipedFrom })
        $PipedFrom |  Should -Be $False
    }
    it 'PipeScript.Automatic.Variable.IsPipedFrom Example 2' {
        & (Use-PipeScript { $IsPipedFrom }) | Foreach-Object { $_ } |  Should -Be $true
    }
}

