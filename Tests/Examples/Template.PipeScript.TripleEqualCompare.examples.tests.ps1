
describe 'Template.PipeScript.TripleEqualCompare' {
    it 'Template.PipeScript.TripleEqualCompare Example 1' {
        Invoke-PipeScript -ScriptBlock {
            $a = 1
            $number = 1    
            if ($a === $number ) {
                "A is $a"
            }
        }
    }
    it 'Template.PipeScript.TripleEqualCompare Example 2' {
        Invoke-PipeScript -ScriptBlock {
            $One = 1
            $OneIsNotANumber = "1"
            if ($one == $OneIsNotANumber) {
                'With ==, a number can be compared to a string, so $a == "1"'
            }
            if (-not ($One === $OneIsNotANumber)) {
                "With ===, a number isn't the same type as a string, so this will be false."            
            }
        }
    }
    it 'Template.PipeScript.TripleEqualCompare Example 3' {
        Invoke-PipeScript -ScriptBlock {
            if ($null === $null) {
                '$Null really is $null'
            }
        }
    }
    it 'Template.PipeScript.TripleEqualCompare Example 4' {
        Invoke-PipeScript -ScriptBlock {
            $zero = 0
            if (-not ($zero === $null)) {
                '$zero is not $null'
            }
        }
    }
    it 'Template.PipeScript.TripleEqualCompare Example 5' {
        {
            $a = "b"
            $a === "b"
        } | .>PipeScript
    }
}

