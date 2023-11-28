function Import-ModuleMember
{
    <#
    .SYNOPSIS
        Imports members into a module
    .DESCRIPTION
        Imports members from an object into a module.
        
        A few types of members can easily be turned into commands:
        * A ScriptMethod with named blocks
        * A Property with a ScriptBlock value
        * A Property with a relative path
         
        Each of these can easily be turned into a function or alias.
    .EXAMPLE        
        $importedMembers = [PSCustomObject]@{
            "Did you know you PowerShell can have commands with spaces" = {
                "It's a pretty unique feature of the PowerShell language"
            }
        } | Import-ModuleMember -PassThru

        $importedMembers # Should -BeOfType ([Management.Automation.PSModuleInfo]) 

        & "Did you know you PowerShell can have commands with spaces" # Should -BeLike '*PowerShell*'
    #>
    [CmdletBinding(PositionalBinding=$false)]
    [Reflection.AssemblyMetadata("HelpOut.TellStory", $true)]
    [Reflection.AssemblyMetadata("HelpOut.Story.Process", "For Each Input")]
    param(
    # The Source of additional module members
    [vfp()]
    [Alias('Source','Member','InputObject')]
    [PSObject[]]
    $From,

    # If provided, will only include members that match any of these wildcards or patterns
    [vbn()]
    [Alias('IncludeMember')]
    [PSObject[]]
    $IncludeProperty,

    # If provided, will exclude any members that match any of these wildcards or patterns
    [vbn()]
    [Alias('ExcludeMember')]
    [PSObject[]]
    $ExcludeProperty,
    
    # The module the members should be imported into.
    # If this is not provided, or the module has already been imported, a dynamic module will be generated.
    [vbn()]
    $Module,

    # Any custom member conversions.
    # If these are provided, they can convert any type of object or value into a member.
    # If this is a Dictionary, `[type]` and `[ScriptBlock]` keys can be used to constrain the type.
    # If this is a PSObject, the property names will be treated as wildcards and the value should be a string or scriptblock that will make the function.
    [vbn()]
    [Alias('ConvertProperty','TransformProperty','TransformMember')]
    [PSObject]
    $ConvertMember,

    # If set, will pass thru any imported members
    # If a new module is created, this will pass thru the created module.
    # If a -Module is provided, and has not yet been imported, then the created functions and aliases will be referenced instead.
    [vbn()]
    [switch]
    $PassThru
    )

    process {
        #region Convert Members to Commands
        # First up, we need to take our input and turn it into something to import        
        $importMembers = :nextObject foreach ($fromObject in $from) {
            # (we turn any dictionary into a psuedo-object, for consistency).
            if ($fromObject -is [Collections.IDictionary]) { 
                $fromObject = [PSCustomObject]$fromObject
            }
            
            :nextMember foreach ($member in $fromObject.PSObject.Members) {
                #region -Including and -Excluding
                # We need to look at each potential member
                # and make sure it's not something we want to -Exclude.
                if ($ExcludeProperty) {
                    foreach ($exProp in $ExcludeProperty) {
                        # If it is, move onto the next member.
                        continue nextMember if (
                            ($exProp -is [regex] -and $member.Name -match $exProp) -or 
                            ($exProp -isnot [regex] -and $member.Name -like $exProp)
                        ) {}
                    }                    
                }
                # If we're whitelisting as well
                if ($IncludeProperty) {
                    included :do {
                        # make sure each item is in the whitelist.
                        foreach ($inProp in $IncludeProperty) {
                            break included if (
                                $inProp -is [Regex] -and $member.Name -match $inProp
                            ) {}
                            break included if (
                                $inProp -isnot [Regex] -and $member.Name -like $inProp
                            ) {}
                        }
                        continue nextMember
                    } while ($false)
                }
                #endregion -Including and -Excluding

                #region Convert Each Member to A Command

                # Now what we're sure we want this member, let's see if we can have it:

                #region Custom Member Conversions
                # If there were custom conversions
                if ($ConvertMember) {
                    # see if it was a dictionary or not.                                        
                    if ($ConvertMember -is [Collections.IDictionary]) {
                        # For dictionaries we can check for a `[type]`, or a `[ScriptBlock]`, or a `[Regex]` or wildcard `[string]`,
                        # so we'll have to walk thru the dictionary
                        foreach ($convertKeyValue in $ConvertMember.GetEnumerator()) {
                            # (skipping anything that does not have a `[ScriptBlock]` value).
                            continue if $convertKeyValue.Value -isnot [scriptblock]

                            # Do we have a match?
                            $GotAMatch = 
                                # If the key is a [type]
                                if ($convertKeyValue.Key -is [type] -and 
                                    # and the member is that type,
                                    $member.Value -is $convertKeyValue.Key) {
                                    $true # we've got a match.
                                }
                                # If the key is `[Regex]`
                                elseif ($convertKeyValue.Key -is [Regex] -and
                                    # and the member name matches the pattern
                                    $member.Name -match $convertKeyValue
                                ) {
                                    $true # we've got a match.
                                }
                                # If the key is a `[ScriptBlock]`
                                elseif ($convertKeyValue.Key -is [scriptblock] -and 
                                    # and it has a truthy result
                                    $(& $convertKeyValue.Key $member)) {
                                    $true # we've got a match.
                                }
                                elseif (
                                    # As a last attempt, it's a member is a match if the pstypenames contains the key
                                    $member.Value.pstypenames -contains $convertKeyValue.Key -or 
                                    # or it's value is like the key.
                                    $member.Value -like $convertKeyValue.Key
                                ) {
                                    $true
                                }

                            # If we have no match, continue
                            continue if -not $GotAMatch

                            # Run the converter.
                            $convertedScriptOutput = & $convertKeyValue.Value $member
                            # If there's output, continue to the next member.
                            continue nextMember if ($convertedScriptOutput) {
                                @{"function:$($member.Name)" = $convertedScriptOutput}
                            }                                
                        }
                    } else {
                        # Otherwise, walk over each property
                        switch ($ConvertMember.psobject.properties) {
                            {
                                # If the value is a scriptblock and 
                                $_.Value -is [ScriptBlock] -and
                                (
                                    # the member's value's typenames contains the convert member name
                                    $member.Value.pstypenames -contains $_.Name -or 
                                    $member.Name -like $_.Name # (or the member's value is like the convert member name )
                                )
                            } {
                                # Run the converter.
                                $convertedScriptOutput = & $_.Value $member
                                # If there's output, continue to the next member.
                                continue nextMember if ($convertedScriptOutput) {
                                    @{"function:$($member.Name)" = $convertedScriptOutput}
                                }
                            }
                        }
                    }
                }
                #endregion Custom Member Conversions

                #region Automatic Member Conversions
                switch ($member.Value) {
                    [ScriptBlock]
                    {
                        # * If it's a `[ScriptBlock]`, it can become a function
                        @{"function:$($member.Name)"= $member.Value} # (just set it directly).
                    }
                    [PSScriptMethod]
                    {
                        # * If it's a `[PSScriptMethod]`, it can also become a function
                        @{"function:$($member.Name)"= $member.Value.Script} # (just set it to the .Script property) (be aware, `$this` will not work without some additional work).
                    }
                    [string]
                    {
                        # For strings, we can see if they are a relative path to the module
                        # (assuming there is a module)
                        if ($module.Path) {
                            $absoluteItemPath =
                                $module |
                                    Split-Path |
                                    Join-Path -ChildPath (
                                        $member.Value -replace '[\\/]',
                                            [IO.Path]::DirectorySeparatorChar
                                    )

                            # If the path exists
                            if (Test-Path $absoluteItemPath) {
                                # alias it.
                                @{"alias:$($member.Name)" = "$absoluteItemPath"}
                            }
                        }
                    }
                }
                #endregion Automatic Member Conversions
                #endregion Convert Each Member to A Command
            }
        }
        

        # If we have no properties we can import, now is the time to return.
        return if -not $importMembers        
        #endregion Convert Members to Commands

        # Now we have to determine how we're declaring and importing these functions.

        # We're either going to be Generating a New Module.
        # or Importing into a Loading Module.
        
        # In these two scenarios we will want to generate a new module:
        if (
            (-not $module) -or # If we did not provide a module (because how else should we import it?)
            ($module.Version -ge '0.0') # or if the module has a version (because during load, a module has no version)
        ) {
            

            #region Generating a New Module
            # To start off, we'll want to timestamp the module
            $timestamp = $([Datetime]::now.ToString('s'))
            # and might want to use our own invocation name to name the module.
            $MyInvocationName = $MyInvocation.InvocationName
            New-Module -ScriptBlock {
                # The definition is straightforward enough,
                foreach ($_ in @($args | & { process { $_.GetEnumerator() }})) {
                    # it just sets each argument with the providers
                    $ExecutionContext.SessionState.InvokeProvider.Item.Set($_.Key, $_.Value, $true)
                }
                # and exports everything.
                Export-ModuleMember -Function * -Variable * -Cmdlet * -Alias *
            } -Name "$(
                # We name the new module based off of the module (if present)
                if ($module) { "$($module.Name)@$timestamp" }
                # or the command name (if not)
                else { "$MyInvocationName@$timestamp"}
            )" -ArgumentList $importMembers | # We pass our ImportMembers as the argument to make it all work
                Import-Module -Global -PassThru:$PassThru -Force # and import the module globally.

            #endregion Generating a New Module
        } 
        elseif ($module -and $module.Version -eq '0.0') 
        {
            #region Importing into a Loading Module
            foreach ($_ in @($importMembers | & { process { $_.GetEnumerator() }})) {
                # If we're importing into a module that hasn't finished loading
                # get a pointer to it's context.
                $moduleContext = . $Module { $ExecutionContext }
                # and use the providers to set the item (and we're good).
                $moduleContext.SessionState.InvokeProvider.Item.Set($_.Key, $_.Value,$true)
                # If -PassThru was provided
                if ($PassThru) {
                    # Pass thru each command.                    
                    $commandType, $commandName = $_.Key -split ':', 2
                    $moduleContext.SessionState.InvokeCommand.GetCommand($commandName, $commandType)
                }
            }
            #endregion Importing into a Loading Module
        }
    }
}
