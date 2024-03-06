[ValidatePattern("Automatic\s{0,}Variable")]
param()

PipeScript.Automatic.Variable function IsPipedTo {
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


PipeScript.Automatic.Variable function IsPipedFrom {
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
