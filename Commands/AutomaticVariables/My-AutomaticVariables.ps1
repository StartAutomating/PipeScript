# Declares various 'my' automatic variables

function PipeScript.Automatic.Variable.MyCallstack {
    <#
    .SYNOPSIS
        $MyCallStack
    .DESCRIPTION
        $MyCallstack is an automatic variable that contains the current callstack.
    #>
    @(Get-PSCallstack) # Set $MyCallstack
}



function PipeScript.Automatic.Variable.MySelf {
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
    $MyInvocation.MyCommand.ScriptBlock # Set $mySelf
}



function PipeScript.Automatic.Variable.MyParameters {
    <#
    .SYNOPSIS
        $MyParameters
    .DESCRIPTION
        $MyParameters is an automatic variable that is a copy of $psBoundParameters.
        This leaves you more free to change it.
    .EXAMPLE
        Invoke-PipeScript -ScriptBlock {
            $MyParameters
        }
    #>
    [Ordered]@{} + $PSBoundParameters
}



function PipeScript.Automatic.Variable.MyCaller {
    <#
    .SYNOPSIS
        $MyCaller
    .DESCRIPTION
        $MyCaller is an automatic variable that contains the CallstackFrame that called this command.
        Also Known As:
        * $CallStackPeek
    .EXAMPLE
        
    #>
    [Alias('Automatic.Variable.CallstackPeek')]
    param()
   
$myCallStack=@(Get-PSCallstack)
 $myCallStack[-1] # Initialize MyCaller
}



function PipeScript.Automatic.Variable.MyCommandAst {
    <#
    .SYNOPSIS
        $MyCommandAst
    .DESCRIPTION
        $MyCommandAst is an automatic variable that contains the abstract syntax tree used to invoke this command.
    #>    
    param()
   
$MyCaller=$($myCallStack=@(Get-PSCallstack)
     $myCallStack[-1])
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

