
describe 'Template.PipeScript.NamespacedObject' {
    it 'Template.PipeScript.NamespacedObject Example 1' {
        Invoke-PipeScript {
            My Object Precious { $IsARing = $true; $BindsThemAll = $true }
            My.Precious
        }
    }
}

