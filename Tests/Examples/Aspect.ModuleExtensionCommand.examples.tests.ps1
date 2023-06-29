
describe 'Aspect.ModuleExtensionCommand' {
    it 'Aspect.ModuleExtensionCommand Example 1' {
        Aspect.ModuleExtensionCommand -Module PipeScript |  Should -BeOfType ([Management.Automation.CommandInfo])
    }
}

