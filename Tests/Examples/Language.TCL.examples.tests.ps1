
describe 'Language.TCL' {
    it 'Language.TCL Example 1' {
    Invoke-PipeScript {
        $tclScript = '    
    # {

    # # Uncommented lines between these two points will be ignored

    #  # Commented lines will become PipeScript / PowerShell.
    # param($message = "hello world")
    # "puts `"$message`""

    # }
    '
    
        [OutputFile('.\HelloWorld.ps1.tcl')]$tclScript
    }

    Invoke-PipeScript .\HelloWorld.ps1.tcl
    }
}

