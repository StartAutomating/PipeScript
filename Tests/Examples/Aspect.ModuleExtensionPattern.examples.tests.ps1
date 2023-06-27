
describe 'Aspect.ModuleExtensionPattern' {
    it 'Aspect.ModuleExtensionPattern Example 1' {
        Aspect.ModuleCommandPattern -Module PipeScript |  Should -BeOfType ([Regex])
    }
    it 'Aspect.ModuleExtensionPattern Example 2' {
                                        # Outputs a PSObject with information about extension command types.
                                        
                                        # The two primary pieces of information are the `.Name` and `.Pattern`.
                                        Aspect.ModuleExtensionType -Module PipeScript |  Should -BeOfType ([PSObject])
    }
}

