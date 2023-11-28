
describe 'Language.Bash' {
    it 'Language.Bash Example 1' {
        Invoke-PipeScript {
            $bashScript = '
            echo ''hello world''

            <<PipeScript{}
                "echo ''$(''hi'',''yo'',''sup'' | Get-Random)''"
            PipeScript{}
        '
        
            [OutputFile('.\HelloWorld.ps1.sh')]$bashScript
        }

        Invoke-PipeScript .\HelloWorld.ps1.sh
    }
}

