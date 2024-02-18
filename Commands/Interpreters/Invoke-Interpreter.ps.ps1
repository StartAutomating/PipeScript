
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
    
    # Store myInvocation (we'll need it often)
    $myInv = $MyInvocation

    # Determine the invocation name
    $invocationName = $MyInvocation.InvocationName
    
    # If we do not have the correct invocation name, that's because the call operator is being used
    # Unfortunately, this makes this more complicated, as we have to go looking
    if ($invocationName -in '.', '&') {
        # Starting off by picking the words after the invocation
        $myLine = $myInv.Line.Substring($myInv.OffsetInLine) -replace '^\s{0,}'
        $MyWords = @($myLine -split '\s{1,}')

        # If the first word is a variable
        if ($MyWords[0] -match '^\$(?<v>\w+)') {            
            $firstWordVariableValue = $ExecutionContext.SessionState.PSVariable.Get($matches.0 -replace '^\s\$').Value
            # and it has a value
            if ($firstWordVariableValue) {
                # use that as the InvocationName.
                $invocationName = $firstWordVariableValue
            }
        }
        # If the first word is not a variable,
        elseif ($MyWords[0] -match '^(?<w>\w+)') {
            # see if it's an alias
            $firstWordAlias = $ExecutionContext.SessionState.InvokeCommand.GetCommand($mywords[0], 'Alias')            
            if ($firstWordAlias.ReferencedCommand -ne $myInv.MyCommand.Name) {
                # and use the referenced command as the invocation name.
                $invocationName = $firstWordAlias
            }
        }
    }
        
    # Return if we were called by our real name.
    return if $invocationName -eq $myInv.MyCommand.Name
    # If there are no interpreters, obviously return.
    return if -not $PSInterpreters
    # If we cannot find mappings 
    return if -not $PSInterpreters.ForFile    
    $interpreterForFiles = $PSInterpreters.ForFile($invocationName)
    # or don't find a mapping, return.
    if (-not $interpreterForFiles -and $invocationName -notmatch '[\&\.]') {
        $nameIsAlias = Get-Alias -Name $InvocationName
        if ($nameIsAlias.ReferencedCommand.Name -ne $myInv.MyCommand.Name) {
            $invocationName = $nameIsAlias.ReferencedCommand.Name
            $interpreterForFiles = $PSInterpreters.ForFile($nameIsAlias.ReferencedCommand)
        }
    }
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