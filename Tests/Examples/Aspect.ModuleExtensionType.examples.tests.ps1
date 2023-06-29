
describe 'Aspect.ModuleExtensionType' {
    it 'Aspect.ModuleExtensionType Example 1' {
        # Outputs a PSObject with information about extension command types.
        
        # The two primary pieces of information are the `.Name` and `.Pattern`.
        Aspect.ModuleExtensionType -Module PipeScript |  Should -BeOfType ([PSObject])
    }
}

