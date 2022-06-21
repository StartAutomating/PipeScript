


describe PipeScript {
    context 'Attribute Based Composition' {
        it 'Can Compose Scripts Using Psuedo-Attributes' {
            . ({
                function f {                
                    param(                
                    [VFP()]
                    $P
                    )            
                }
            } | .>Pipescript)
            $IsVfp = @($ExecutionContext.SessionState.InvokeCommand.GetCommand('f', 'Function').Parameters['P'].Attributes.ValueFromPipeline) -ne $null
            $IsVfp | Should -not -be $null
        }
    }

    it 'Can transpile a scriptblock that is preceeded by the name of a transpiler' {
        Invoke-PipeScript -ScriptBlock {
            [bash]{param($msg = 'hello world') $msg}
        } -ErrorAction Stop |
            Should -BeLike '*!/usr/bin/env bash*pwsh*-command*$@*' 
    }
    
    it 'Can make output explicit' {
        Invoke-PipeScript -ScriptBlock {
            [explicit]{1;echo 2;3}
        } | should -be 2

        Invoke-PipeScript -ScriptBlock {
            [explicit()]
            param()
            1;echo 2;3
        } | should -be 2 

        Invoke-PipeScript -ScriptBlock {
            [explicit]{
                1;echo 2;3;
                Write-Output (4..5);
                1,2,3|
                    Measure-Object -Sum -average | Write-Output;
                $a = 1..2 | Measure-Object
            } 
        } | Select-Object -First 1 | Should -be 2        
    }
    
    it 'Will leave normal attributes alone' {
        {
            [OutputType([string])]
            param()
            "hello"
        } | .>Pipescript | Should -BeLike '*?OutputType??string???*'
    }

    it 'Can transpile a function' {
        {
            function [explicit]ExplicitOutput {
                "whoops"
                return 1
            }
        } | .>PipeScript |
            Should -BeLike "*function ExplicitOutput*`$null?=?`"whoops`"*return 1*"
    }    
}

