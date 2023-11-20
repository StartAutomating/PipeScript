
describe 'Route.Uptime' {
    it 'Route.Uptime Example 1' {
        Get-PipeScript -PipeScriptType Route |
            Where-Object Name -Match 'Uptime' |
            Foreach-Object { & $_ }
    }
}

