
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




function PipeScript.Automatic.Variable.IsPipedFrom {
    <#
    .SYNOPSIS
        $IsPipedFrom
    .DESCRIPTION
        $IsPipedFrom is an automatic variable that determines if the pipeline continues after this command.
    .EXAMPLE
        & (Use-PipeScript { $IsPipedFrom }) # Should -Be $False
    .EXAMPLE
        & (Use-PipeScript { $IsPipedFrom }) | Foreach-Object { $_ } # Should -Be $False
    #>    
    param()
    $myInvocation.PipelinePosition -lt $myInvocation.PipelineLength
}


