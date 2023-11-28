function Import-ModuleMember {


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
    param(
    # The Source of additional module members
    [Parameter(ValueFromPipeline)]
    [Alias('Source','Member','InputObject')]
    [PSObject[]]
    $From,

    # If provided, will only include members that match any of these wildcards or patterns
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('IncludeMember')]
    [PSObject[]]
    $IncludeProperty,

    # If provided, will exclude any members that match any of these wildcards or patterns
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ExcludeMember')]
    [PSObject[]]
    $ExcludeProperty,
    
    # The module the members should be imported into.
    # If this is not provided, or the module has already been imported, a dynamic module will be generated.
    [Parameter(ValueFromPipelineByPropertyName)]
    $Module,

    # If set, will pass thru any imported members
    # If a new module is created, this will pass thru the created module.
    # If a -Module is provided, and has not yet been imported, then the created functions and aliases will be referenced instead.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $PassThru
    )

    process {
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
                        if (($exProp -is [regex] -and $member.Name -match $exProp) -or 
                                                    ($exProp -isnot [regex] -and $member.Name -like $exProp)) { 
                                    continue nextMember                        
                                }                         
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
                {$_ -is [ScriptBlock]}
                {
                                        # If it's a [ScriptBlock], it can become a function
                                        @{"function:$($member.Name)"= $member.Value}
                                    }
                {$_ -is [PSScriptMethod]}
                {
                                        # If it's a [PSScriptMethod], it can also become a function
                                        @{"function:$($member.Name)"= $member.Value.Script}
                                    }
                {$_ -is [PSScriptProperty]}
                {
                                        # ScriptProperties can be functions, too
                                        @{"function:$($member.Name)"= $member.Value.GetterScript}
                                        
                                    }
                {$_ -is [string]}
                {
                                        if ($module.Path) {                            
                                            $absoluteItemPath = 
                                                $module | 
                                                    Split-Path | 
                                                    Join-Path -ChildPath (
                                                        $member.Value -replace '[\\/]',
                                                            [IO.Path]::DirectorySeparatorChar
                                                    )
                
                                            if (Test-Path $absoluteItemPath) {
                                                @{"alias:$($member.Name)" = "$absoluteItemPath"}    
                                            }
                                        }
                                    }
                }
            }
        }

        if (-not $importMembers) { return }        

        if ((-not $module) -or ($module.Version -ge '0.0')) {
            $timestamp = $([Datetime]::now.ToString('s'))
            $MyInvocationName = $MyInvocation.InvocationName
            $newModule = New-Module -ScriptBlock {
                foreach ($_ in @($args | & { process { $_.GetEnumerator() }})) {
                    $ExecutionContext.SessionState.InvokeProvider.Item.Set($_.Key, $_.Value)
                }
                Export-ModuleMember -Function * -Variable * -Cmdlet *                
            } -ArgumentList $importMembers -Name "$(if ($module) { "$($module.Name)@$timestamp" } else { "$MyInvocationName@$timestamp"})"
            $newModule | Import-Module -Global -PassThru:$PassThru -Force
        } elseif ($module -and $module.Version -eq '0.0') {
            foreach ($_ in @($importMembers | & { process { $_.GetEnumerator() }})) {
                $moduleContext = . $Module { $ExecutionContext }
                $ExecutionContext.SessionState.InvokeProvider.Item.Set($_.Key, $_.Value)
                if ($PassThru) {
                    $commandType, $commandName = $_.Key -split ':', 2
                    $ExecutionContext.SessionState.InvokeCommand.GetCommand($commandName, $commandType)
                }
            }
        }
    }



}

