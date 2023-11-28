
describe 'Language.Python' {
    it 'Language.Python Example 1' {
    .> {
       $pythonContent = @'
"""{
$msg = "Hello World", "Hey There", "Howdy" | Get-Random
@"
print("$msg")
"@
}"""
'@
        [OutputFile('.\HelloWorld.ps1.py')]$PythonContent
    }

    .> .\HelloWorld.ps1.py
    }
    it 'Language.Python Example 2' {
    'print("Hello World")' > .\HelloWorld.py
    Invoke-PipeScript .\HelloWorld.py |  Should -Be 'Hello World'
    }
}

