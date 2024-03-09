
describe 'Template.PipeScript.Inherit' {
    it 'Template.PipeScript.Inherit Example 1' {
        Invoke-PipeScript {
            [inherit("Get-Command")]
            param()
        }
    }
    it 'Template.PipeScript.Inherit Example 2' {
        {
            [inherit("gh",Overload)]
            param()
            begin { "ABOUT TO CALL GH"}
            end { "JUST CALLED GH" }
        }.Transpile()
    }
    it 'Template.PipeScript.Inherit Example 3' {
        # Inherit Get-Transpiler abstractly and make it output the parameters passed in.
        {
            [inherit("Get-Transpiler", Abstract)]
            param() process { $psBoundParameters }
        }.Transpile()
    }
    it 'Template.PipeScript.Inherit Example 4' {
        {
            [inherit("Get-Transpiler", Dynamic, Abstract)]
            param()
        } | .>PipeScript
    }
}

