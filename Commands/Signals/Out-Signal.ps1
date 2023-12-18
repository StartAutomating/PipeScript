
function Signal.Out {


    <#
    .SYNOPSIS
        Outputs a Signal
    .DESCRIPTION
        Outputs a Signal with whatever name, arguments, input, and command.

        A signal is a PowerShell event.
    .EXAMPLE
        Out-Signal "hello"
    .EXAMPLE
        Set-Alias MySignal Out-Signal
        MySignal
    #>
    [Alias('Out-Signal','Out.Signal')]
    param()
    
   
$MyCommandAst=$($MyCaller=$($myCallStack=@(Get-PSCallstack)
         $myCallStack[-1])
     if ($MyCaller) {
            $myInv = $MyInvocation
            $MyCaller.InvocationInfo.MyCommand.ScriptBlock.Ast.FindAll({
                param($ast) 
                    $ast.Extent.StartLineNumber -eq $myInv.ScriptLineNumber -and
                    $ast.Extent.StartColumnNumber -eq $myInv.OffsetInLine -and 
                    $ast -is [Management.Automation.Language.CommandAst]
            },$true)
        })
 New-Event -SourceIdentifier $MyInvocation.InvocationName -MessageData ([PSCustomObject][Ordered]@{
        Arguments = $args
        Input     = @($input)
        Command   = $MyCommandAst
    })



}

