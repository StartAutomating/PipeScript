
describe 'Parse-PowerShell' {
    it 'Parse-PowerShell Example 1' {
        Get-ChildItem *.ps1 | 
            Parse-PowerShell
    }
    it 'Parse-PowerShell Example 2' {
        Parse-PowerShell "'hello world'"
    }
}

