<#
.SYNOPSIS
    Gets dynamic parameters
.DESCRIPTION
    Gets dynamic parameters for a command
#>
param()

$DynamicParameterSplat = [Ordered]@{}
$dynamicParametersFrom =@(foreach ($arg in $args | & { process{ $_ } } ) {
    if ($arg -is [CommandInfo] -or $arg -is [ScriptBlock]) {
        $arg
    }
    if ($arg -is [Collections.IDictionary]) {
        foreach ($keyValuePair in $arg.GetEnumerator()) {
            $DynamicParameterSplat[$keyValuePair.Key] = $keyValuePair.Value
        }
    }
})

if (-not $dynamicParametersFrom) { return }

$dynamicParametersFrom | 
    # Aspect.DynamicParameter
    & { 
    
    
        <#
        .SYNOPSIS
            Dynamic Parameter Aspect
        .DESCRIPTION
            The Dynamic Parameter Aspect is used to add dynamic parameters, well, dynamically.
    
            It can create dynamic parameters from one or more input objects or scripts.
        .EXAMPLE
            Get-Command Get-Command | 
                Aspect.DynamicParameter
        .EXAMPLE
            Get-Command Get-Process | 
                Aspect.DynamicParameter -IncludeParameter Name # Select -Expand Keys # Should -Be Name
        .EXAMPLE
            Get-Command Get-Command, Get-Help | 
                Aspect.DynamicParameter
        #>
        [Alias('Aspect.DynamicParameters')]
        param(
        # The InputObject.
        # This can be anything, but will be ignored unless it is a `[ScriptBlock]` or `[Management.Automation.CommandInfo]`.    
        [Parameter(ValueFromPipeline)]
        $InputObject,
    
        # The name of the parameter set the dynamic parameters will be placed into.    
        [string]
        $ParameterSetName,
    
        # The positional offset.  If this is provided, all positional parameters will be shifted by this number.
        # For example, if -PositionOffset is 1, the first parameter would become the second parameter (and so on)
        [int]
        $PositionOffset,
    
        # If set, will make all dynamic parameters non-mandatory.
        [switch]
        $NoMandatory,
    
        # If provided, will check that dynamic parameters are valid for a given command.
        # If the [Management.Automation.CmdletAttribute]
        [string[]]
        $commandList,
    
        # If provided, will include only these parameters from the input.
        [string[]]
        $IncludeParameter,
    
        # If provided, will exclude these parameters from the input.
        [string[]]
        $ExcludeParameter,
    
        # If provided, will make a blank parameter for every -PositionOffset.
        # This is so, presumably, whatever has already been provided in these positions will bind correctly.
        # The name of this parameter, by default, will be "ArgumentN" (for example, Argument1)
        [switch]
        $BlankParameter,
    
        # The name of the blank parameter.
        # If there is a -PositionOffset, this will make a blank parameter by this name for the position.    
        [string[]]
        $BlankParameterName = "Argument"
        )
    
        begin {
            # We're going to accumulate all input into a queue, so we'll need to make a queue in begin.
            $inputQueue = [Collections.Queue]::new()
        }
        process {
            $inputQueue.Enqueue($InputObject) # In process, we just need to enqueue the input.
        }
    
        end {
            # The dynamic parameters are created at the end of the pipeline.        
            $DynamicParameters = [Management.Automation.RuntimeDefinedParameterDictionary]::new()
            
            # We're going to want to track what aliases are assigned (to avoid conflicts)
            $PendingAliasMap = [Ordered]@{}
    
            # Before any dynamic parameters are bound, we need to create any blank requested parameters
            if ($PositionOffset -and # (if we're offsetting position
                ($BlankParameter -or $PSBoundParameters['BlankParameterName']) # and we have a -BlankParameter)
            ) {
    
                for ($pos =0; $pos -lt $PositionOffset; $pos++) {
                    # If we have a name, use that
                    $paramName = $BlankParameterName[$pos]
                    if (-not $paramName) {
                        # Otherwise, just use the last name and give it a number.
                        $paramName = "$($BlankParameterName[-1])$pos"
                    }
                    # construct a minimal dynamic parameter                
                    $DynamicParameters.Add($paramName, 
                        [Management.Automation.RuntimeDefinedParameter]::new(
                            $paramName,
                            [PSObject], 
                            @(
                                $paramAttr = [Management.Automation.ParameterAttribute]::new()
                                $paramAttr.Position = $pos
                                $paramAttr
                            )
                        )
                    )
    
                    $PendingAliasMap[$paramName] = $DynamicParameters[$paramName]
                }
            }
    
            # After we've blank parameters, we move onto the input queue.        
            while ($inputQueue.Count) {
                # and work our way thru it until it is empty.
                $InputObject = $inputQueue.Dequeue()
    
                # First up, we turn our input into [CommandMetaData]
                $inputCmdMetaData = 
                    if ($inputObject -is [Management.Automation.CommandInfo]) {
                        # this is a snap if it's a command already
                        [Management.Automation.CommandMetaData]$InputObject
                    }
                    elseif ($inputObject -is [scriptblock]) {
                        # but scriptblocks need to be put into a temporary function.
                        $function:TempFunction = $InputObject
                        [Management.Automation.CommandMetaData]$ExecutionContext.SessionState.InvokeCommand.GetCommand('TempFunction','Function')
                    }
    
                # If for any reason we couldn't get command metadata, continue.
                if (-not $inputCmdMetaData) { continue } 
                                                       
                :nextDynamicParameter foreach ($paramName in $inputCmdMetaData.Parameters.Keys) {
                    if ($ExcludeParameter) {
                        foreach ($exclude in $ExcludeParameter) {
                            if ($paramName -like $exclude) { continue nextDynamicParameter}
                        }
                    }
                    if ($IncludeParameter) {
                        $shouldInclude = 
                            foreach ($include in $IncludeParameter) {
                                if ($paramName -like $include) { $true;break}
                            }
                        if (-not $shouldInclude) { continue nextDynamicParameter }
                    }
    
                    $attrList = [Collections.Generic.List[Attribute]]::new()
                    $validCommandNames = @()
                    foreach ($attr in $inputCmdMetaData.Parameters[$paramName].attributes) {
                        if (
                            $attr -isnot [Management.Automation.ParameterAttribute] -and
                            $attr -isnot [Management.Automation.AliasAttribute]
                        ) {
                            # we can passthru any non-parameter attributes
                            $attrList.Add($attr)
                            # (`[Management.Automation.CmdletAttribute]` is special, as it indicates if the parameter applies to a command)
                            if ($attr -is [Management.Automation.CmdletAttribute] -and $commandList) {
                                $validCommandNames += (
                                    ($attr.VerbName -replace '\s') + '-' + ($attr.NounName -replace '\s')
                                ) -replace '^\-' -replace '\-$'
                            }
                        } 
                        elseif ($attr -is [Management.Automation.AliasAttribute]) {
                            # If it is an alias attribute, we need to ensure that it will not conflict with existing aliases
                            $unmappedAliases = @(foreach ($a in $attr.Aliases) {
                                if (($a -in $pendingAliasMap.Keys)) { continue } 
                                $a
                            })
                            if ($unmappedAliases) {
                                $attrList.Add([Management.Automation.AliasAttribute]::new($unmappedAliases))
                                foreach ($nowMappedAlias in $unmappedAliases) {
                                    $PendingAliasMap[$nowMappedAlias] = $DynamicParameters[$paramName]
                                }
                            }
                        }
                        else {
                            # but parameter attributes need to copied.
                            $attrCopy = [Management.Automation.ParameterAttribute]::new()
                            # (Side note: without a .Clone, copying is tedious.)
                            foreach ($prop in $attrCopy.GetType().GetProperties('Instance,Public')) {
                                if (-not $prop.CanWrite) { continue }
                                if ($null -ne $attr.($prop.Name)) {
                                    $attrCopy.($prop.Name) = $attr.($prop.Name)
                                }
                            }
    
                            $attrCopy.ParameterSetName =
                                if ($ParameterSetName) {
                                    $ParameterSetName
                                }
                                else {
                                    $defaultParamSetName = $inputCmdMetaData.DefaultParameterSetName
                                    if ($attrCopy.ParameterSetName -ne '__AllParameterSets') {
                                        $attrCopy.ParameterSetName
                                    }
                                    elseif ($defaultParamSetName) {
                                        $defaultParamSetName
                                    }
                                    elseif ($this -is [Management.Automation.FunctionInfo]) {
                                        $this.Name
                                    } elseif ($this -is [Management.Automation.ExternalScriptInfo]) {
                                        $this.Source
                                    }
                                }
    
                            if ($NoMandatory -and $attrCopy.Mandatory) {
                                $attrCopy.Mandatory = $false
                            }
    
                            if ($PositionOffset -and $attr.Position -ge 0) {
                                $attrCopy.Position += $PositionOffset
                            }
                            $attrList.Add($attrCopy)
                        }
                    }
    
                    if ($commandList -and $validCommandNames) {
                        :CheckCommandValidity do {
                            foreach ($vc in $validCommandNames) {
                                if ($commandList -match $vc) { break CheckCommandValidity }
                            }
                            continue nextDynamicParameter
                        } while ($false)
                    }
                    
                    if ($DynamicParameters.ContainsKey($paramName)) {                    
                        $DynamicParameters[$paramName].ParameterType = [PSObject]
                        foreach ($attr in $attrList) {                        
                            $DynamicParameters[$paramName].Attributes.Add($attr)
                        }
                    } else {
                        $DynamicParameters.Add($paramName, [Management.Automation.RuntimeDefinedParameter]::new(
                            $inputCmdMetaData.Parameters[$paramName].Name,
                            $inputCmdMetaData.Parameters[$paramName].ParameterType,
                            $attrList
                        ))
                    }
                }
            }
            $DynamicParameters
        }
    
    
     } @DyanmicParameterOption
