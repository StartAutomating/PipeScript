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
    #>
    param()
    $MyInvocation.MyCommand.ScriptBlock
}
