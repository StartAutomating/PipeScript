describe "'until' keyword" {    
    it "Is a loop that runs until the condition is false" {
        Invoke-PipeScript { 
            $x = 0 
            until ($x -ge 10) {
                $x++
            }
            $x
        } | Should -Be 10
    }
    it 'Can have a loop label' {
        Invoke-PipeScript { 
            $x = 0 
            :thisUntil until ($x -ge 10) {
                $x++
                break thisUntil
            }
            $x
        } | Should -Be 10
    }
}


