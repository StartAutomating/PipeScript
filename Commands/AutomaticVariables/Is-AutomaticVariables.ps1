
function PipeScript.Automatic.Variable.IsPipedTo {

    <#
    .SYNOPSIS
        $IsPipedTo
    .DESCRIPTION
        $IsPipedTo determines if a command is being piped to.
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
        $IsPipedFrom determines if the pipeline continues after this command.
    .EXAMPLE
        $PipedFrom = & (Use-PipeScript { $IsPipedFrom })
        $PipedFrom # Should -Be $False
    .EXAMPLE
        & (Use-PipeScript { $IsPipedFrom }) | Foreach-Object { $_ } # Should -Be $true
    #>    
    param()
    $myInvocation.PipelinePosition -lt $myInvocation.PipelineLength

}


