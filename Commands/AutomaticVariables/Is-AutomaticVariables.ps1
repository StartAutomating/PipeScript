
function PipeScript.Automatic.Variable.IsPipedTo {
    <#
    .SYNOPSIS
        $IsPipedTo
    .DESCRIPTION
        $IsPipedTo is an automatic variable that determines if a command is being piped to.
    .EXAMPLE
        & (Use-PipeScript { $IsPipedTo }) # Should -Be $False
    .EXAMPLE
        1 | & (Use-PipeScript { $IsPipedTo }) # Should -Be $True
    #>    
    param()
    $myInvocation.ExpectingInput
}


