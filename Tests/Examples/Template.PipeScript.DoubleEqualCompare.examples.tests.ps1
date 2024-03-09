
describe 'Template.PipeScript.DoubleEqualCompare' {
    it 'Template.PipeScript.DoubleEqualCompare Example 1' {
        Invoke-PipeScript -ScriptBlock {
            $a = 1    
            if ($a == 1 ) {
                "A is $a"
            }
        }
    }
    it 'Template.PipeScript.DoubleEqualCompare Example 2' {
        {
            $a == "b"
        } | .>PipeScript
    }
}

