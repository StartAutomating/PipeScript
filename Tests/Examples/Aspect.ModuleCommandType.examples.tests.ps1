
describe 'Aspect.ModuleCommandType' {
    it 'Aspect.ModuleCommandType Example 1' {
        # Outputs a series of PSObjects with information about command types.
        # The two primary pieces of information are the `.Name` and `.Pattern`.
        Aspect.ModuleCommandType -Module PipeScript | Should -BeOfType ([PSObject])
    }
}

