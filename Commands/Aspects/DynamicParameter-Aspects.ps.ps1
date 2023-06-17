Aspect function DynamicParameter {
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
            Aspect.DynamicParameter -IncludeParameter Name # Select -Expand Key | Should -Be Name
    #>
    [Alias('Aspect.DynamicParameters')]
    param(
    # The InputObject.
    # This can be anything, but will be ignored unless it is a `[ScriptBlock]` or `[Management.Automation.CommandInfo]`.    
    [vfp()]
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
        $inputQueue = [Collections.Queue]::new()
    }
    process {
        $inputQueue.Enqueue($InputObject)
    }

    end {        
        $DynamicParameters = [Management.Automation.RuntimeDefinedParameterDictionary]::new()

        if ($PositionOffset -and 
            ($BlankParameter -or $PSBoundParameters['BlankParameterName'])) {
            for ($pos =0; $pos -lt $PositionOffset; $pos++) {
                $paramName = $BlankParameterName[$pos]
                if (-not $paramName) {
                    $paramName = "$($BlankParameterName[-1])$pos"
                }                
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
            }
        }
        while ($inputQueue.Count) {
            $InputObject = $inputQueue.Dequeue()

            $inputCmdMetaData = 
                if ($inputObject -is [Management.Automation.CommandInfo]) {
                    [Management.Automation.CommandMetaData]$InputObject
                }
                elseif ($inputObject -is [scriptblock]) {
                    $function:TempFunction = $InputObject
                    [Management.Automation.CommandMetaData]$ExecutionContext.SessionState.InvokeCommand.GetCommand('TempFunction','Function')
                }

            continue if -not $inputCmdMetaData
                                        
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
                    if ($attr -isnot [Management.Automation.ParameterAttribute]) {
                        # we can passthru any non-parameter attributes
                        $attrList.Add($attr)
                        # (`[Management.Automation.CmdletAttribute]` is special, as it indicates if the parameter applies to a command)
                        if ($attr -is [Management.Automation.CmdletAttribute] -and $commandList) {
                            $validCommandNames += (
                                ($attr.VerbName -replace '\s') + '-' + ($attr.NounName -replace '\s')
                            ) -replace '^\-' -replace '\-$'
                        }
                    } else {
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
}