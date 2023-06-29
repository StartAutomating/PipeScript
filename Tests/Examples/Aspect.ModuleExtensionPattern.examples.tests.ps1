
describe 'Aspect.ModuleExtensionPattern' {
    it 'Aspect.ModuleExtensionPattern Example 1' {
        Aspect.ModuleCommandPattern -Module PipeScript |  Should -BeOfType ([Regex])
    }
}

