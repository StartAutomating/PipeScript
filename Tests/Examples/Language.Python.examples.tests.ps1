
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
}

