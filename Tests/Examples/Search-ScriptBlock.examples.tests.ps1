
describe 'Search-ScriptBlock' {
    it 'Search-ScriptBlock Example 1' {
        Search-PipeScript -ScriptBlock {
            $a
            $b
            $c
            "text"
        } -AstType Variable
    }
}

