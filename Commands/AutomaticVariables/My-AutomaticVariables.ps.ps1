[ValidatePattern("Automatic\s{0,}Variable")]
param()

# Declares various 'my' automatic variables
PipeScript.Automatic.Variable function MyCallstack {
    <#
    .SYNOPSIS
        $MyCallStack
    .DESCRIPTION
        $MyCallstack is an automatic variable that contains the current callstack.
    #>
    @(Get-PSCallstack) # Set $MyCallstack
}

PipeScript.Automatic.Variable function MySelf {
    <#
    .SYNOPSIS
        $MySelf
    .DESCRIPTION
        $MySelf contains the currently executing ScriptBlock.

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
    $MyInvocation.MyCommand.ScriptBlock # Set $mySelf
}

PipeScript.Automatic.Variable function MyParameters {
    <#
    .SYNOPSIS
        $MyParameters
    .DESCRIPTION
        $MyParameters contains a copy of $psBoundParameters.

        This leaves you more free to change it.
    .EXAMPLE
        Invoke-PipeScript -ScriptBlock {
            $MyParameters
        }
    #>
    [Ordered]@{} + $PSBoundParameters
}

PipeScript.Automatic.Variable function MyCaller {
    <#
    .SYNOPSIS
        $MyCaller
    .DESCRIPTION
        $MyCaller (aka $CallStackPeek) contains the CallstackFrame that called this command.    
    .EXAMPLE
        Invoke-PipeScript { $myCaller }
    #>
    [Alias('Automatic.Variable.CallstackPeek')]
    param()
    $myCallStack[-1] # Initialize MyCaller
}

PipeScript.Automatic.Variable function MyCommandAst {
    <#
    .SYNOPSIS
        $MyCommandAst
    .DESCRIPTION
        $MyCommandAst contains the abstract syntax tree used to invoke this command.
    .EXAMPLE
        & (Use-PipeScript { $myCommandAst })
    #>    
    param()
    if ($MyCaller) {
        $myInv = $MyInvocation
        $MyCaller.InvocationInfo.MyCommand.ScriptBlock.Ast.FindAll({
            param($ast) 
                $ast.Extent.StartLineNumber -eq $myInv.ScriptLineNumber -and
                $ast.Extent.StartColumnNumber -eq $myInv.OffsetInLine -and 
                $ast -is [Management.Automation.Language.CommandAst]
        },$true)
    }
}