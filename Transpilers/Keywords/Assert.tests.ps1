describe "'assert' Keyword" {    
    it "Supports assertions when -Debug is passed" {
        {
            Invoke-PipeScript {
                assert (1 -eq 2)
            } -Debug
        } | Should -Throw
    }

    it "Supports assertions when -Verbose is passed" {
        {
            Invoke-PipeScript {
                assert (1 + 1 -eq 3) "One plus one does not equal 3"
            } -Verbose
        } | Should -Throw
    }

    it 'Ignores assertions when -Debug or -Verbose is not passed' {            
        Invoke-PipeScript {
            assert (1 + 1 -eq 3) "One plus one does not equal 3"
        }        
    }    
}

