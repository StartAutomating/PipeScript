
describe 'Aspect.ModuleExtendedCommand' {
    it 'Aspect.ModuleExtendedCommand Example 1' {
        Aspect.ModuleExtendedCommand -Module PipeScript |  Should -BeOfType ([Management.Automation.CommandInfo])
    }
    it 'Aspect.ModuleExtendedCommand Example 2' {
                                  Aspect.ModuleCommandPattern -Module PipeScript |  Should -BeOfType ([Regex])
    }
}

