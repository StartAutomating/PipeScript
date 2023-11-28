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
            # We need to look at each potential member
            :nextMember foreach ($member in $fromObject.PSObject.Members) {
                # and make sure it's not something we want to -Exclude.
                if ($ExcludeProperty) {
                    foreach ($exProp in $ExcludeProperty) {
                        # If it is, move onto the next member
                        continue nextMember if (
                            ($exProp -is [regex] -and $member.Name -match $exProp) -or 
                            ($exProp -isnot [regex] -and $member.Name -like $exProp)
                        ) {}                        
                    }                    
                }
                # If we're whitelisting as well
                if ($IncludeProperty) {
                    included :do {
                        # make sure each item is in the whitelist
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

                # Now what we're sure we want this member, let's see if we can have it:                 
                switch ($member.Value) {
                    [ScriptBlock]
                    {
                        # If it's a [ScriptBlock], it can become a function
                        @{"function:$($member.Name)"= $member.Value}
                    }
                    [PSScriptMethod]
                    {
                        # If it's a [PSScriptMethod], it can also become a function
                        @{"function:$($member.Name)"= $member.Value.Script}
                    }
                    [PSScriptProperty]
                    {
                        # ScriptProperties can be functions, too
                        @{"function:$($member.Name)"= $member.Value.GetterScript}
                        
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
