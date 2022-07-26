describe "'new' keyword" {    
    it "Creates new objects (like one would expect)" {
        Invoke-PipeScript { 
            $int = new int
            $int -eq 0
        } | Should -Be $true
    }
    it "Can also ::Parse a type if it cannot be constructed" {
        Invoke-PipeScript {
            $byte = new byte 254
        }
    }
    it "Can can also ::Create an object" {
        Invoke-PipeScript {
            (new ScriptBlock).GetType()
        } | Should -Be ([scriptblock])
    }
}

