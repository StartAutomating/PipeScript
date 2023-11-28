
describe 'Language.R' {
    it 'Language.R Example 1' {
    Invoke-PipeScript {
        $rScript = '    
    # {

    Uncommented lines between these two points will be ignored

    #  # Commented lines will become PipeScript / PowerShell.
    # param($message = "hello world")
    # "print(`"$message`")"

    # }
    '
    
        [OutputFile('.\HelloWorld.ps1.r')]$rScript
    }

    Invoke-PipeScript .\HelloWorld.ps1.r
    }
}

