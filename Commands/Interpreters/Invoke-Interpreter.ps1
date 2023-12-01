
function Invoke-Interpreter {


    <#
    .SYNOPSIS
        Invokes Interpreters
    .DESCRIPTION
        Invokes an Interpreter.

        This command is not used directly, it is used by creating an alias to invoke-interpreter.
    
        This will happen automatically as you attempt to use commands that have an associated interpreter
    #>
    param()
    $myInv = $MyInvocation
    $invocationName = $MyInvocation.InvocationName
    # Return if we were called by our real name.
    if ($invocationName -eq $myInv.MyCommand.Name) { return }
    # If there are no interpreters, obviously return.
    if (-not $PSInterpreters) { return }
    # If we cannot find mappings 
    if (-not $PSInterpreters.ForFile) { return }    
    $interpreterForFile = $PSInterpreters.ForFile($invocationName)
    # or don't find a mapping, return.
    if (-not $interpreterForFile) { return }
    
    $interpreterCommand, $leadingArgs = $interpreterForFile.Interpreter
    # If there was no interpreter command, return.
    if (-not $interpreterCommand) { return }
    
    $leadingArgs = @($leadingArgs)
    if ($MyInvocation.ExpectingInput) {
        $input | & $interpreterCommand @leadingArgs $invocationName @args
    } else {
        & $interpreterCommand @leadingArgs $invocationName @args
    }    


}
