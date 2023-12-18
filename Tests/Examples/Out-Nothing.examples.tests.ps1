
describe 'Out-Nothing' {
    it 'Out-Nothing Example 1' {
        1..1mb | Signal.Nothing
    }
    it 'Out-Nothing Example 2' {
        1..1kb | null
    }
}

