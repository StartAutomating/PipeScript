
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
    $interpreterForFiles = $PSInterpreters.ForFile($invocationName)
    # or don't find a mapping, return.
    if (-not $interpreterForFiles) { return }
    
    # There can be more than one potential interpreter for each file
    :NextInterpreter foreach ($interpreterForFile in $interpreterForFiles) {
        $interpreterCommand, $leadingArgs = $interpreterForFile.Interpreter
        # If there was no interpreter command, return.
        if (-not $interpreterCommand) { continue }         
        
        $leadingArgs = @($leadingArgs)
        
        # Now things get a little more complicated.
        
        # Since many things that will interpret our arguments will _not_ be PowerShell, we want to conver them
        $convertedArguments =
            @(
                # Unless, of course, the interpreter is native PowerShell, 
                # which we can know if .HasPowerShellInterpreter is true
                if ($interpreterForFile.HasPowerShellInterpreter) {
                    $args | . { process { $_ } }
            } else {
                # If it does not have a PowerShell interpreter,
                $args | 
                        . { process {
                            # Then non-string arguments should become JSON
                            if ($_ -isnot [string]) {
                                ConvertTo-Json -InputObject $_ -Depth 100
                            } else {
                                $_
                            }
                        } }
            })
        
        if ($leadingArgs) {
            if ($MyInvocation.ExpectingInput) {
                $input | & $interpreterCommand @leadingArgs $invocationName @convertedArguments
            } else {
                & $interpreterCommand @leadingArgs $invocationName @convertedArguments
            }
        } else {
            if ($MyInvocation.ExpectingInput) {
                $input | & $interpreterCommand $invocationName @convertedArguments
            } else {
                & $interpreterCommand $invocationName @convertedArguments
            }
        }
    }            

}
