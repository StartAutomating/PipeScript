
describe 'Search-PipeScript' {
    it 'Search-PipeScript Example 1' {
        Search-PipeScript -ScriptBlock {
            $a
            $b
            $c
            "text"
        } -AstType Variable
    }
}

