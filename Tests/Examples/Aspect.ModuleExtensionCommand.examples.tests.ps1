
describe 'Aspect.ModuleExtensionCommand' {
    it 'Aspect.ModuleExtensionCommand Example 1' {
        Aspect.ModuleExtensionCommand -Module PipeScript |  Should -BeOfType ([Management.Automation.CommandInfo])
    }
    it 'Aspect.ModuleExtensionCommand Example 2' {
                                        Aspect.ModuleCommandPattern -Module PipeScript |  Should -BeOfType ([Regex])
    }
    it 'Aspect.ModuleExtensionCommand Example 3' {
                                                                        # Outputs a PSObject with information about extension command types.
                                                                        
                                                                        # The two primary pieces of information are the `.Name` and `.Pattern`.
                                                                        Aspect.ModuleExtensionType -Module PipeScript |  Should -BeOfType ([PSObject])
    }
    it 'Aspect.ModuleExtensionCommand Example 4' {
                                        # Outputs a PSObject with information about extension command types.
                                        
                                        # The two primary pieces of information are the `.Name` and `.Pattern`.
                                        Aspect.ModuleExtensionType -Module PipeScript |  Should -BeOfType ([PSObject])
    }
}

