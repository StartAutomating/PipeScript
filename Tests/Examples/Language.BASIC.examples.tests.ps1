
describe 'Language.BASIC' {
    it 'Language.BASIC Example 1' {
Invoke-PipeScript {
    $VBScript = '    
rem {

rem # Uncommented lines between these two points will be ignored

rem # Commented lines will become PipeScript / PowerShell.
rem param($message = "hello world")
rem "CreateObject(`"WScript.Shell`").Popup(`"$message`")" 
rem }
'

    [OutputFile('.\HelloWorld.ps1.vbs')]$VBScript
}

Invoke-PipeScript .\HelloWorld.ps1.vbs
    }
}

