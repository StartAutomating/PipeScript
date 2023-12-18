
describe 'Language.Batch' {
    it 'Language.Batch Example 1' {
Invoke-PipeScript {
    $batchScript = '    
:: {

:: # Uncommented lines between these two points will be ignored

:: # Commented lines will become PipeScript / PowerShell.
:: param($message = "hello world")
:: "echo $message"

:: }
'

    [OutputFile('.\HelloWorld.ps1.cmd')]$batchScript
}

Invoke-PipeScript .\HelloWorld.ps1.cmd
    }
}

