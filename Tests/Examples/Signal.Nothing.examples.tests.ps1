
describe 'Signal.Nothing' {
    it 'Signal.Nothing Example 1' {
        1..1mb | Signal.Nothing
    }
    it 'Signal.Nothing Example 2' {
        1..1kb | null
    }
}

