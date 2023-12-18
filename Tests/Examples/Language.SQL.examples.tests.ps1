
describe 'Language.SQL' {
    it 'Language.SQL Example 1' {
    Invoke-PipeScript {
        $SQLScript = '    
    -- {

    Uncommented lines between these two points will be ignored

    --  # Commented lines will become PipeScript / PowerShell.
    -- param($message = "hello world")
    -- "-- $message"
    -- }
    '
    
        [OutputFile('.\HelloWorld.ps1.sql')]$SQLScript
    }

    Invoke-PipeScript .\HelloWorld.ps1.sql
    }
}

