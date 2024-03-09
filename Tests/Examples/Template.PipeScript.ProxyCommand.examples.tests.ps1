
describe 'Template.PipeScript.ProxyCommand' {
    it 'Template.PipeScript.ProxyCommand Example 1' {
        .\ProxyCommand.psx.ps1 -CommandName Get-Process
    }
    it 'Template.PipeScript.ProxyCommand Example 2' {
        {
            function [ProxyCommand<'Get-Process'>]GetProcessProxy {}
        } | .>PipeScript
    }
    it 'Template.PipeScript.ProxyCommand Example 3' {
        .>ProxyCommand -CommandName Get-Process -RemoveParameter *
    }
    it 'Template.PipeScript.ProxyCommand Example 4' {
        Invoke-PipeScript -ScriptBlock {[ProxyCommand('Get-Process')]param()}
    }
    it 'Template.PipeScript.ProxyCommand Example 5' {
        Invoke-PipeScript -ScriptBlock {
            [ProxyCommand('Get-Process', 
                RemoveParameter='*',
                DefaultParameter={
                    @{id='$pid'}
                })]
                param()
        }
    }
    it 'Template.PipeScript.ProxyCommand Example 6' {
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

