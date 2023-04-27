describe 'http protocol' {
    it 'Runs http[s] commands' {
        .> https://api.github.com/repos/StartAutomating/PipeScript |
            Select-Object -ExpandProperty Name |
            Should -be PipeScript
    }

    it 'Can include variables in the syntax' {
        .> {
            $userName, $repo = 'StartAutomating', 'PipeScript'
            https://api.github.com/repos/$userName/$repo |
                Select-Object -ExpandProperty Name |
                Should -be PipeScript
        }
    }
}
