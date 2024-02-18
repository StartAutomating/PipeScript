
describe 'Language.Python' {
    it 'Language.Python Example 1' {
    'print("Hello World")' > .\HelloWorld.py
    Invoke-PipeScript .\HelloWorld.py
    }
    it 'Language.Python Example 2' {
    Template.HelloWorld.py -Message "Hi" | Set-Content ".\Hi.py"
    Invoke-PipeScript .\Hi.py
    }
}

