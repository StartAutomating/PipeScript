
describe 'Export-Json' {
    it 'Export-Json Example 1' {
        1..10 | Export-Json -Path .\Test.json
    }
}

