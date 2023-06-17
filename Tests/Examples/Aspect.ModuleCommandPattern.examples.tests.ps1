
describe 'Aspect.ModuleCommandPattern' {
    it 'Aspect.ModuleCommandPattern Example 1' {
        Aspect.ModuleCommandPattern -Module PipeScript |  Should -BeOfType ([Regex])
    }
}

