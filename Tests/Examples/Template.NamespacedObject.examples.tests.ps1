
describe 'Template.NamespacedObject' {
    it 'Template.NamespacedObject Example 1' {
        Invoke-PipeScript {
            My Object Precious { $IsARing = $true; $BindsThemAll = $true }
            My.Precious
        }
    }
}

