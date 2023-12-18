
describe 'ConvertFrom-CliXml' {
    it 'ConvertFrom-CliXml Example 1' {
        dir | ConvertTo-Clixml | ConvertFrom-Clixml
    }
}

