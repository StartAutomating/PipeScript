
describe 'Language.JSON' {
    it 'Language.JSON Example 1' {
        Invoke-PipeScript {
            a.json template "{
            procs : null/*{Get-Process | Select Name, ID}*/
            }"
        }
    }
}

