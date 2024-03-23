function Search-Command {
    <#
    .SYNOPSIS
        Searches commands
    .DESCRIPTION
        Searches loaded commands as quickly as possible.
    .NOTES
        Get-Command is somewhat notoriously slow, and command lookup is one of the more expensive parts of PowerShell.

        This command is designed to speedily search for commands by name, module, verb, noun, or pattern.

        Because Search-Command is built for speed, it will _not_ autodiscover commands.
    #>
    [OutputType([Management.Automation.CommandInfo])]
    param(
    # The name of the command
    [vbn()]
    [Alias('Like')]
    [string[]]
    $Name = '*',

    # One or more patterns to match.
    [vbn()]
    [Alias('Match','Matches')]
    [PSObject[]]
    $Pattern,

    # The module the command should be in.
    [vbn()]
    [PSObject[]]
    $Module,

    # The verb of the command.
    # This will be treated as the start of the command name (before any punctuation).
    [vbn()]
    [string[]]
    $Verb,

    # The noun of the command
    # This will be treated as the end of the command name (after any punctuation).
    [vbn()]
    [string[]]
    $Noun,

    # A pattern for the parameter name.
    # Only commands that have a parameter name or alias matching this will be returned.
    [vbn()]
    [string[]]
    $ParameterName,

    # A pattern for the parameter type.
    # Only commands that have a parameter type matching this will be returned.
    # If `-ParameterName` is also provided, it will ensure these parameters have a type that match this pattern.
    [vbn()]
    [psobject[]]
    $ParameterType,

    # A pattern for the output type.
    # Only commands that have an output type matching this will be returned.
    [vbn()]
    [PSObject[]]
    $OutputType,

    # A pattern for the input type.
    # Only commands that have an input type matching this will be returned.
    # (only pipeline parameters are considered as input types)
    [vbn()]
    [PSObject[]]
    $InputType,
    
    # The type of command to search for.
    [vbn()]
    [Alias('CommandTypes')]
    [Management.Automation.CommandTypes]
    $CommandType = 'Alias,Function,Cmdlet'
    )

    begin {
        # This command is built for speed.
        # It will cache all lookups.
        if (-not $script:CommandLookupCache) {
            $script:CommandLookupCache = [Ordered]@{}
        }

        # It will also declare inner ScriptBlocks instead of inner functions
        # (this avoids command lookup, and is faster)
        
        # To Search the command cache
        $SearchCommandCache = {
            # If there was a list of patterns
            if ($PatternList) {
                # check each pattern
                foreach ($searchPattern in $PatternList) {
                    # against the cache command pointer
                    $script:CommandLookupCache[$lookupKeys] -match $searchPattern
                }
            } else {
                # otherwise, get all the commands
                $script:CommandLookupCache[$lookupKeys]
            }
        }

        # To filter values
        $FilterValues = { process {
                # check each object
                $in = $_

                # against each post condition
                foreach ($thisPostCondition in $PostConditions) {
                    $this = $_ = $in
                    
                    $conditionOutput = . $thisPostCondition
                    # and if it passes, return it
                    if (-not $conditionOutput) { return  }
                }

                return $in
        } }

        # To unroll values, simply pass them thru.
        $UnrollValues = { process {  $_ } }
    }

    process {
        # Get our lookup keys
        $lookupKeys = @(            
            foreach ($cmdName in $name) {
                $lookupKey = "[$commandType]/$cmdName"
                if (-not $script:CommandLookupCache[$lookupKey]) {
                    # by caching the pointer to the commands list, we can rapidly filter and easily know when new commands are added.
                    $script:CommandLookupCache[$lookupKey] = $global:ExecutionContext.InvokeCommand.GetCommands($cmdName, $commandType,$true)
                }
                $lookupKey
            }        
        )

        # Determine the list of patterns, given our parameters.
        $PatternList = @(
            if ($pattern) { $pattern}
            if ($noun) {
                "\p{P}(?>$($noun -join '|'))"
            }
            if ($verb) {
                "^$($verb -join '|')\p{P}"
            }
        )

        # Determine the list of post conditions, given our parameters.
        $PostConditions = @(
            # First, filter by module.
            if ($module) {
                
                if ($module -match '\*') {
                    # We'll use `-like` for wildcard matching,
                    { foreach ($mod in $module) { if ($_.Module.Name -like $mod) { return $true } } }
                } else {
                    # and `-eq` for exact matching.
                    { foreach ($mod in $module) { if ($_.Module.Name -eq $mod) { return $true } } }
                }                
            }

            # Next, filter by parameter name.
            if ($ParameterName) {
                {
                    # Combine all parameter names and aliases into a single regex pattern.
                    $AnyParameterName = [Regex]::new("^(?>$($ParameterName -join '|'))$",'IgnoreCase,IgnorePatternWhitespace','00:00:00.001')
                    # Check if any parameter name matches the pattern.
                    @($_.Parameters.Keys;$_.Parameters.Values.Aliases) -match $AnyParameterName
                }
            }
            if ($parameterType) {
                { 
                    # Combine all parameter types into a single regex pattern.
                    $AnyParameterType = [Regex]::new("(?>$($ParameterType -replace '\.','\.' -join '|'))",'IgnoreCase,IgnorePatternWhitespace','00:00:00.001')
                    # If we have a parameter name, filter by that first
                    @(if ($ParameterName) {
                        $in.Parameters[@(
                            $AnyParameterName = [Regex]::new("^(?>$($ParameterName -join '|'))$",'IgnoreCase,IgnorePatternWhitespace','00:00:00.001')
                            @($_.Parameters.Keys;$_.Parameters.Values.Aliases) -match $AnyParameterName
                        )].ParameterType.Fullname
                    } else {
                        $in.Parameters.Values.ParameterType.Fullname
                    }) -match $AnyParameterType # check if any parameter type matches the pattern.
                }
            }
            if ($OutputType) {
                {
                    # Combine all output types into a single regex pattern. 
                    $anyOutputType = [Regex]::new("(?>$($OutputType -join '|'))",'IgnoreCase,IgnorePatternWhitespace','00:00:00.001')
                    # Check if any output type matches the pattern.
                    $_.OutputType.Name -match $anyOutputType
                }
            }            
        )

        if (-not $PostConditions) {
            . $SearchCommandCache | 
                . $UnrollValues
        } else {
            . $SearchCommandCache | 
                . $UnrollValues | 
                . $FilterValues
        }
    }
}
