
describe 'Invoke-PipeScript' {
    it 'Invoke-PipeScript Example 1' {
        # PipeScript is a superset of PowerShell.
        # So a hello world in PipeScript is the same as a "Hello World" in PowerShell:

        Invoke-PipeScript { "hello world" } |  Should -Be "Hello World"
    }
    it 'Invoke-PipeScript Example 2' {
        # Invoke-PipeScript will invoke a command, ScriptBlock, file, or AST element as PipeScript.
        Invoke-PipeScript { all functions } |  Should -BeOfType ([Management.Automation.FunctionInfo])
    }
}

