# Declares various 'my' automatic variables
Automatic.Variable Alias MyCallstack Get-PSCallstack

Automatic.Variable function MySelf {
    <#
    .SYNOPSIS
        $MySelf
    .DESCRIPTION
        $MySelf is an automatic variable that contains the currently executing ScriptBlock.

        A Command can & $myself to use anonymous recursion.
    .EXAMPLE
        {
            $mySelf
        } | Use-PipeScript
    .EXAMPLE
        # By using $Myself, we can write an anonymously recursive fibonacci sequence.
        Invoke-PipeScript {
            param([int]$n = 1)

            if ($n -lt 2) {
                $n
            } else {
                (& $myself ($n -1)) + (& $myself ($n -2))
            }
        } -ArgumentList 10
    #>    
    $MyInvocation.MyCommand.ScriptBlock
}

Automatic.Variable function MyParameters {
    <#
    .SYNOPSIS
        $MyParameters
    .DESCRIPTION
        $MyParameters is an automatic variable that is a copy of $psBoundParameters.

        This leaves you more free to change it.
    #>
    param()
    [Ordered]@{} + $PSBoundParameters
}