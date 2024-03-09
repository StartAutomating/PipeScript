
describe 'Template.PipeScript.ExplicitOutput' {
    it 'Template.PipeScript.ExplicitOutput Example 1' {
        Invoke-PipeScript {
            [explicit()]
            param()
            "This Will Not Output"
            Write-Output "This Will Output"
        }
    }
    it 'Template.PipeScript.ExplicitOutput Example 2' {
        {
            [explicit]{
                1,2,3,4
                echo "Output"
            }
        } | .>PipeScript
    }
}

