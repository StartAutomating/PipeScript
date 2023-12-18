
describe 'PipeScript.Optimizer.ConsolidateAspects' {
    it 'PipeScript.Optimizer.ConsolidateAspects Example 1' {
        {        
            a.txt Template 'abc'

            b.txt Template 'abc'
        } | .>PipeScript
    }
    it 'PipeScript.Optimizer.ConsolidateAspects Example 2' {
        {
            aspect function SayHi {
                if (-not $args) { "Hello World"}
                else { $args }
            }
            function Greetings {
                SayHi
                SayHi "hallo Welt"
            }
        } | .>PipeScript
    }
}

