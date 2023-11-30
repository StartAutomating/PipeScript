
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
    return if $invocationName -eq $myInv.MyCommand.Name
    # If there are no interpreters, obviously return.
    return if -not $PSInterpreters
    # If we cannot find mappings 
    return if -not $PSInterpreters.ForFile    
    $interpreterForFile = $PSInterpreters.ForFile($invocationName)
    # or don't find a mapping, return.
    return if -not $interpreterForFile
    
    $interpreterCommand, $leadingArgs = $interpreterForFile.Interpreter
    # If there was no interpreter command, return.
    return if -not $interpreterCommand
    
    $leadingArgs = @($leadingArgs)
    if ($MyInvocation.ExpectingInput) {
        $input | & $interpreterCommand @leadingArgs $invocationName @args
    } else {
        & $interpreterCommand @leadingArgs $invocationName @args
    }    
}