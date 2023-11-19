
describe 'Route.VersionInfo' {
    it 'Route.VersionInfo Example 1' {
        Get-PipeScript -PipeScriptType Route |
            Where-Object Name -Match 'VersionInfo' |
            Foreach-Object { & $_ }
    }
}

