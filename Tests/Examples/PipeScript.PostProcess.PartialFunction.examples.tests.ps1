
describe 'PipeScript.PostProcess.PartialFunction' {
    it 'PipeScript.PostProcess.PartialFunction Example 1' {
        Import-PipeScript {
            partial function testPartialFunction {
                "This will be added to a command name TestPartialFunction"
            }
            
            function testPartialFunction {}
        }

        testPartialFunction |  Should -BeLike '*TestPartialFunction*'
    }
}

