
describe 'Import-PipeScript' {
    it 'Import-PipeScript Example 1' {
        Import-PipeScript -ScriptBlock {
            function gh {
                [Inherit('gh',CommandType='Application')]
                param()
            }
        }
    }
    it 'Import-PipeScript Example 2' {
        Import-PipeScript -ScriptBlock {
            partial function f {
                "This will be added to any function named f."
            }
        }
    }
}

