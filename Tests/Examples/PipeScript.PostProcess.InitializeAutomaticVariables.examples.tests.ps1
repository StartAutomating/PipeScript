
describe 'PipeScript.PostProcess.InitializeAutomaticVariables' {
    it 'PipeScript.PostProcess.InitializeAutomaticVariables Example 1' {
        # Declare an automatic variable, MyCallStack
        Import-PipeScript {
            Automatic.Variable function MyCallstack {
                Get-PSCallstack
            }
        }

        # Now we can use $MyCallstack as-is.
        # It will be initialized at the beginning of the script
        {
            $MyCallstack
        } | Use-PipeScript
    }
}

