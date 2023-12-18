
describe 'Signal.Out' {
    it 'Signal.Out Example 1' {
        Out-Signal "hello"
    }
    it 'Signal.Out Example 2' {
        Set-Alias MySignal Out-Signal
        MySignal
    }
}

