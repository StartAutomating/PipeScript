describe "Conditional Keywords" {
    context "For example" {
        it "Is cool that you can {break if `$true}" {
            {
                break if $true
            } | .>PipeScript | 
            Should -BeLike '*if*(*$true*)*{*break*}*'
        }
        it "It cool that you can also {continue if `$true}" {
            {
                continue if $true
            } | .>PipeScript | 
            Should -BeLike '*if*(*$true*)*{*continue*}*'
        }
    }
    
    context "Being thorough" {
        it "Is handy that you can {break toLabel if (`$true) {}}" {
            {
                break toLabel if ($true) {}
            } | .>PipeScript | 
            Should -BeLike '*if*(*$true*)*{*break*tolabel*}*'
        }

        it "Is handy that you can {continue toLabel if (`$true) {}}" {
            {
                continue toLabel if ($true) {}
            } | .>PipeScript | 
            Should -BeLike '*if*(*$true*)*{*continue*tolabel*}*'
        }
    }    
}
