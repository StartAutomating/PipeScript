
describe 'Language.ADA' {
    it 'Language.ADA Example 1' {
        Invoke-PipeScript {
            $AdaScript = '    
        with Ada.Text_IO;

        procedure Hello_World is
        begin
            -- {

            Uncommented lines between these two points will be ignored

            --  # Commented lines will become PipeScript / PowerShell.
            -- param($message = "hello world")        
            -- "Ada.Text_IO.Put_Line (`"$message`");"
            -- }
        end Hello_World;    
        '
        
            [OutputFile('.\HelloWorld.ps1.adb')]$AdaScript
        }

        Invoke-PipeScript .\HelloWorld.ps1.adb
    }
}

