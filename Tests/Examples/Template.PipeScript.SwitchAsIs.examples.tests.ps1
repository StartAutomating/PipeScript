
describe 'Template.PipeScript.SwitchAsIs' {
    it 'Template.PipeScript.SwitchAsIs Example 1' {
        1..10 | Invoke-PipeScript {
            switch ($_) {
                [int] { $_ } 
                [double] { $_ }
            }
        }
    }
}

