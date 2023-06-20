
describe 'Get-PipeScript' {
    it 'Get-PipeScript Example 1' {
        Get-PipeScript
    }
    it 'Get-PipeScript Example 2' {
        Get-PipeScript -PipeScriptType Transpiler
    }
    it 'Get-PipeScript Example 3' {
        Get-PipeScript -PipeScriptType Template -PipeScriptPath Template
    }
    it 'Get-PipeScript Example 4' {
        PipeScript Invoke { "hello world"}
    }
    it 'Get-PipeScript Example 5' {
        { partial function f { } }  | PipeScript Import -PassThru
    }
    it 'Get-PipeScript Example 6' {
                            Get-Command Get-Command | 
                                Aspect.DynamicParameter
    }
    it 'Get-PipeScript Example 7' {
                            Get-Command Get-Process | 
                                Aspect.DynamicParameter -IncludeParameter Name | Select -Expand Keys |  Should -Be Name
    }
    it 'Get-PipeScript Example 8' {
                                                Aspect.ModuleExtendedCommand -Module PipeScript |  Should -BeOfType ([Management.Automation.CommandInfo])
    }
    it 'Get-PipeScript Example 9' {
                                                                          Aspect.ModuleCommandPattern -Module PipeScript |  Should -BeOfType ([Regex])
    }
    it 'Get-PipeScript Example 10' {
                                                                          Aspect.ModuleCommandPattern -Module PipeScript |  Should -BeOfType ([Regex])
    }
    it 'Get-PipeScript Example 11' {
                                      Aspect.ModuleCommandPattern -Module PipeScript |  Should -BeOfType ([Regex])
    }
}

