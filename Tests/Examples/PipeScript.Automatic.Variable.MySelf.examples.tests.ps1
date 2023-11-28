
describe 'PipeScript.Automatic.Variable.MySelf' {
    it 'PipeScript.Automatic.Variable.MySelf Example 1' {
        {
            $mySelf
        } | Use-PipeScript
    }
    it 'PipeScript.Automatic.Variable.MySelf Example 2' {
        # By using $Myself, we can write an anonymously recursive fibonacci sequence.
        Invoke-PipeScript {
            param([int]$n = 1)

            if ($n -lt 2) {
                $n
            } else {
                (& $myself ($n -1)) + (& $myself ($n -2))
            }
        } -ArgumentList 10
    }
}

