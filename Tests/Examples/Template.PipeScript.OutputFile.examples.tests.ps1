
describe 'Template.PipeScript.OutputFile' {
    it 'Template.PipeScript.OutputFile Example 1' {
        Invoke-PipeScript {
            [OutputFile("hello.txt")]
            param()

            'hello world'
        }
    }
    it 'Template.PipeScript.OutputFile Example 2' {
        Invoke-PipeScript {
            param()

            $Message = 'hello world'
            [Save(".\Hello.txt")]$Message
        }
    }
}

