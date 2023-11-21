
describe 'Out-Signal' {
    it 'Out-Signal Example 1' {
        Out-Signal "hello"
    }
    it 'Out-Signal Example 2' {
        Set-Alias MySignal Out-Signal
        MySignal
    }
}

