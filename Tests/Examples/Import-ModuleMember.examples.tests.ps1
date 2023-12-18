
describe 'Import-ModuleMember' {
    it 'Import-ModuleMember Example 1' {
        $importedMembers = [PSCustomObject]@{
            "Did you know you PowerShell can have commands with spaces" = {
                "It's a pretty unique feature of the PowerShell language"
            }
        } | Import-ModuleMember -PassThru

        $importedMembers # Should -BeOfType ([Management.Automation.PSModuleInfo]) 

        & "Did you know you PowerShell can have commands with spaces" |  Should -BeLike '*PowerShell*'
    }
}

