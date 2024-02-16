
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
    $interpreterForFiles = $PSInterpreters.ForFile($invocationName)
    # or don't find a mapping, return.
    return if -not $interpreterForFiles
    
    # There can be more than one potential interpreter for each file
    :NextInterpreter foreach ($interpreterForFile in $interpreterForFiles) {
        $interpreterCommand, $leadingArgs = $interpreterForFile.Interpreter
        # If there was no interpreter command, return.
        continue if -not $interpreterCommand
                
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
        
        # We want to use splatting for both sets of arguments,
        # so force leading args into an array
        $leadingArgs = @($leadingArgs)

        # If there were leading args
        if ($leadingArgs) {
            # append the invocation name to the array
            $leadingArgs += @($invocationName)
        } else {
            # otherwise, the invocation name is the only leading argument (and we do not want blanks)
            $leadingArgs = @($invocationName)
        }

        # Just before we run, see if we have any parsers for the command
        $ParsersForCommand = $PSParser.ForCommand($invocationName)
                
        # If we do, we'll pipe to Out-Parser.
        if ($ParsersForCommand) {
            if ($MyInvocation.ExpectingInput) {
                $input | 
                    & $interpreterCommand @leadingArgs @convertedArguments | 
                    Out-Parser -CommandLine $invocationName
            } else {
                & $interpreterCommand @leadingArgs @convertedArguments | 
                    Out-Parser -CommandLine $invocationName
            }
        } else {
            if ($MyInvocation.ExpectingInput) {
                $input | & $interpreterCommand @leadingArgs @convertedArguments
            } else {
                & $interpreterCommand @leadingArgs @convertedArguments
            }
        }
    }
}