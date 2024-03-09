
describe 'Template.PipeScript.ProxyCommand' {
    it 'Template.PipeScript.ProxyCommand Example 1' {
        ProxyCommand -CommandName Get-Process -RemoveParameter *
    }
    it 'Template.PipeScript.ProxyCommand Example 2' {
        Invoke-PipeScript -ScriptBlock {[ProxyCommand('Get-Process')]param()}
    }
    it 'Template.PipeScript.ProxyCommand Example 3' {
        Invoke-PipeScript -ScriptBlock {
            [ProxyCommand('Get-Process', 
                RemoveParameter='*',
                DefaultParameter={
                    @{id='$pid'}
                })]
                param()
        }
    }
    it 'Template.PipeScript.ProxyCommand Example 4' {
        { 
            function Get-MyProcess {
                [ProxyCommand('Get-Process', 
                    RemoveParameter='*',
                    DefaultParameter={
                        @{id='$pid'}
                    })]
                    param()
            } 
        } | .>PipeScript
    }
}
