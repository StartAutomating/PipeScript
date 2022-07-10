#region Piecemeal [ 0.3.2 ] : Easy Extensible Plugins for PowerShell
# Install-Module Piecemeal -Scope CurrentUser 
# Import-Module Piecemeal -Force 
# Install-Piecemeal -ExtensionNoun 'Transpiler' -ExtensionPattern '\.psx\.ps1$' -ExtensionTypeName 'PipeScript.Transpiler' -OutputPath '.\Get-Transpiler.ps1'
function Get-Transpiler
{
    <#
    .Synopsis
        Gets Extensions
    .Description
        Gets Extensions.

        Transpiler can be found in:

        * Any module that includes -TranspilerModuleName in it's tags.
        * The directory specified in -TranspilerPath
    .Example
        Get-Transpiler
    #>
    [OutputType('Extension')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSReviewUnusedParameter", "", Justification="PSScriptAnalyzer cannot handle nested scoping")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidAssignmentToAutomaticVariable", "", Justification="Desired for scenario")]
    param(
    # If provided, will look beneath a specific path for extensions.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Fullname')]
    [string]
    $TranspilerPath,

    # If set, will clear caches of extensions, forcing a refresh.
    [switch]
    $Force,

    # If provided, will get Transpiler that extend a given command
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ThatExtends', 'For')]
    [string[]]
    $CommandName,

    <#
    
    The name of an extension.
    By default, this will match any extension command whose name, displayname, or aliases exactly match the name.

    If the extension has an Alias with a regular expression literal (```'/Expression/'```) then the -TranspilerName will be valid if that regular expression matches.
    #>
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $TranspilerName,
    
    <#

    If provided, will treat -TranspilerName as a wildcard.
    This will return any extension whose name, displayname, or aliases are like the -TranspilerName.

    If the extension has an Alias with a regular expression literal (```'/Expression/'```) then the -TranspilerName will be valid if that regular expression matches.
    #>
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Like,

    <#
    
    If provided, will treat -TranspilerName as a regular expression.
    This will return any extension whose name, displayname, or aliases match the -TranspilerName.
    
    If the extension has an Alias with a regular expression literal (```'/Expression/'```) then the -TranspilerName will be valid if that regular expression matches.
    #>
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Match,

    # If set, will return the dynamic parameters object of all the Transpiler for a given command.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $DynamicParameter,

    # If set, will return if the extension could run.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('CanRun')]
    [switch]
    $CouldRun,

    # If set, will return if the extension could accept this input from the pipeline.
    [Alias('CanPipe')]
    [PSObject]
    $CouldPipe,

    # If set, will run the extension.  If -Stream is passed, results will be directly returned.
    # By default, extension results are wrapped in a return object.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Run,

    # If set, will stream output from running the extension.
    # By default, extension results are wrapped in a return object.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Stream,

    # If set, will return the dynamic parameters of all Transpiler for a given command, using the provided DynamicParameterSetName.
    # Implies -DynamicParameter.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $DynamicParameterSetName,


    # If provided, will return the dynamic parameters of all Transpiler for a given command, with all positional parameters offset.
    # Implies -DynamicParameter.
    [Parameter(ValueFromPipelineByPropertyName)]
    [int]
    $DynamicParameterPositionOffset = 0,

    # If set, will return the dynamic parameters of all Transpiler for a given command, with all mandatory parameters marked as optional.
    # Implies -DynamicParameter.  Does not actually prevent the parameter from being Mandatory on the Extension.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('NoMandatoryDynamicParameters')]
    [switch]
    $NoMandatoryDynamicParameter,

    # If set, will require a [Runtime.CompilerServices.Extension()] attribute to be considered an extension.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $RequireTranspilerAttribute,

    # If set, will validate this input against [ValidateScript], [ValidatePattern], [ValidateSet], and [ValidateRange] attributes found on an extension.
    [Parameter(ValueFromPipelineByPropertyName)]
    [PSObject]
    $ValidateInput,

    # If set, will validate this input against all [ValidateScript], [ValidatePattern], [ValidateSet], and [ValidateRange] attributes found on an extension.
    # By default, if any validation attribute returned true, the extension is considered validated.
    [switch]
    $AllValid,

    # The name of the parameter set.  This is used by -CouldRun and -Run to enforce a single specific parameter set.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $ParameterSetName,

    # The parameters to the extension.  Only used when determining if the extension -CouldRun.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Collections.IDictionary]
    [Alias('Parameters','ExtensionParameter','ExtensionParameters')]
    $Parameter = [Ordered]@{},

    # If set, will output a steppable pipeline for the extension.
    # Steppable pipelines allow you to control how begin, process, and end are executed in an extension.
    # This allows for the execution of more than one extension at a time.
    [switch]
    $SteppablePipeline,

    # If set, will output the help for the extensions
    [switch]
    $Help,

    # If set, will get help about one or more parameters of an extension
    [string[]]
    $ParameterHelp,

    # If set, will get help examples
    [Alias('Examples')]
    [switch]
    $Example,

    # If set, will output the full help for the extensions
    [switch]
    $FullHelp
    )

    begin {
        $TranspilerPattern = '\.psx\.ps1$'
        $TranspilerTypeName = 'PipeScript.Transpiler'
        #region Define Inner Functions
        function WhereExtends {
            param(
            [Parameter(Position=0)]
            [string[]]
            $Command,

            [Parameter(ValueFromPipeline)]
            [PSObject]
            $ExtensionCommand
            )

            process {
                if ($TranspilerName) {
                    $ExtensionCommandAliases = @($ExtensionCommand.Attributes.AliasNames)
                    $ExtensionCommandAliasRegexes = @($ExtensionCommandAliases -match '^/' -match '/$')
                    if ($ExtensionCommandAliasRegexes) {
                        $ExtensionCommandAliases = @($ExtensionCommandAliases -notmatch '^/' -match '/$')
                    }
                    :CheckExtensionName do {
                        foreach ($exn in $TranspilerName) {
                            if ($like) {
                                if (($extensionCommand -like $exn) -or
                                    ($extensionCommand.DisplayName -like $exn) -or
                                    ($ExtensionCommandAliases -like $exn)) { break CheckExtensionName }
                            }
                            elseif ($match) {
                                if (($ExtensionCommand -match $exn) -or
                                    ($extensionCommand.DisplayName -match $exn) -or
                                    ($ExtensionCommandAliases -match $exn)) { break CheckExtensionName }
                            }
                            elseif (($ExtensionCommand -eq $exn) -or
                                ($ExtensionCommand.DisplayName -eq $exn) -or
                                ($ExtensionCommandAliases -eq $exn)) { break CheckExtensionName }
                            elseif ($ExtensionCommandAliasRegexes) {
                                foreach ($extensionAliasRegex in $ExtensionCommandAliasRegexes) {                            
                                    $extensionAliasRegex = [Regex]::New($extensionAliasRegex -replace '^/' -replace '/$', 'IgnoreCase,IgnorePatternWhitespace')
                                    if ($extensionAliasRegex -and $extensionAliasRegex.IsMatch($exn)) {
                                        break CheckExtensionName
                                    }
                                }
                            }
                        }
                        

                        return
                    } while ($false)
                }
                if ($Command -and $ExtensionCommand.Extends -contains $command) {
                    $commandExtended = $ext
                    return $ExtensionCommand
                }
                elseif (-not $command) {
                    return $ExtensionCommand
                }
            }
        }
        filter ConvertToExtension {
            $in = $_
            $extCmd =
                if ($in -is [Management.Automation.CommandInfo]) {
                    $in
                }
                elseif ($in -is [IO.FileInfo]) {
                    $ExecutionContext.SessionState.InvokeCommand.GetCommand($in.fullname, 'ExternalScript,Application')
                }
                else {
                    $ExecutionContext.SessionState.InvokeCommand.GetCommand($in, 'Function,ExternalScript,Application')
                }

            $extCmd.PSObject.Methods.Add([psscriptmethod]::new('GetExtendedCommands', {

                $extendedCommandNames = @(
                    foreach ($attr in $this.ScriptBlock.Attributes) {
                        if ($attr -isnot [Management.Automation.CmdletAttribute]) { continue }
                        (
                            ($attr.VerbName -replace '\s') + '-' + ($attr.NounName -replace '\s')
                        ) -replace '^\-' -replace '\-$'                        
                    }
                )
                if (-not $extendedCommandNames) {
                    $this | Add-Member NoteProperty Extends @() -Force
                    $this | Add-Member NoteProperty ExtensionCommands @() -Force
                    return    
                }
                $allLoadedCmds = $ExecutionContext.SessionState.InvokeCommand.GetCommands('*','All', $true)
                $extends = @{}
                foreach ($loadedCmd in $allLoadedCmds) {
                    foreach ($extensionCommandName in $extendedCommandNames) {
                        if ($extensionCommandName -and $loadedCmd.Name -match $extensionCommandName) {
                            $loadedCmd
                            $extends[$loadedCmd.Name] = $loadedCmd
                        }
                    }
                }

                if (-not $extends.Count) {
                    $extends = $null
                }

                $this | Add-Member NoteProperty Extends $extends.Keys -Force
                $this | Add-Member NoteProperty ExtensionCommands $extends.Values -Force
            }))

            $null = $extCmd.GetExtendedCommands()

            $inheritanceLevel = [ComponentModel.InheritanceLevel]::Inherited

            $extCmd.PSObject.Properties.Add([psscriptproperty]::New('BlockComments', {
                [Regex]::New("                   
                \<\# # The opening tag
                (?<Block> 
                    (?:.|\s)+?(?=\z|\#>) # anything until the closing tag
                )
                \#\> # the closing tag
                ", 'IgnoreCase,IgnorePatternWhitespace', '00:00:01').Matches($this.ScriptBlock)
            }))

            $extCmd.PSObject.Methods.Add([psscriptmethod]::New('GetHelpField', {
                param([Parameter(Mandatory)]$Field)
                foreach ($block in $this.BlockComments) {
                    foreach ($match in [Regex]::new("
                        \.(?<Field>$Field)                   # Field Start
                        [\s-[\r\n]]{0,}                      # Optional Whitespace
                        [\r\n]+                              # newline
                        (?<Content>(.|\s)+?(?=(\.\w+|\#\>))) # Anything until the next .\field or end of the comment block
                        ", 'IgnoreCase,IgnorePatternWhitespace', [Timespan]::FromSeconds(1)).Matches(
                            $block.Value
                        )) {
                        $match.Groups["Content"].Value -replace '[\s\r\n]+$'
                    }                    
                }
            }))

            $extCmd.PSObject.Properties.Add([PSNoteProperty]::new('InheritanceLevel', $inheritanceLevel))
            $extCmd.PSObject.Properties.Add([PSScriptProperty]::new(
                'DisplayName', [ScriptBlock]::Create("`$this.Name -replace '$extensionFullRegex'")
            ))
            $extCmd.PSObject.Properties.Add([PSScriptProperty]::new(
                'Attributes', {$this.ScriptBlock.Attributes}
            ))


            $extCmd.PSObject.Properties.Add([PSScriptProperty]::new(
                'Category', {
                    foreach ($attr in $this.ScriptBlock.Attributes) {
                        if ($attr -is [Reflection.AssemblyMetaDataAttribute] -and
                            $attr.Key -eq 'Category') {
                            $attr.Value
                        }
                        elseif ($attr -is [ComponentModel.CategoryAttribute]) {
                            $attr.Category
                        }
                    }
                    
                }
            ))

            $extCmd.PSObject.Properties.Add([PSScriptProperty]::new(
                'Rank', {
                    foreach ($attr in $this.ScriptBlock.Attributes) {
                        if ($attr -is [Reflection.AssemblyMetaDataAttribute] -and
                            $attr.Key -in 'Order', 'Rank') {
                            return $attr.Value -as [int]
                        }
                    }
                    return 0
                }
            ))
            
            $extCmd.PSObject.Properties.Add([psscriptproperty]::new(
                'Metadata', {
                    $Metadata = [Ordered]@{}
                    foreach ($attr in $this.ScriptBlock.Attributes) {
                        if ($attr -is [Reflection.AssemblyMetaDataAttribute]) {
                            if ($Metadata[$attr.Key]) {
                                $Metadata[$attr.Key] = @($Metadata[$attr.Key]) + $attr.Value
                            } else {
                                $Metadata[$attr.Key] = $attr.Value
                            }                            
                        }
                    }
                    return $Metadata
                }
            ))

            $extCmd.PSObject.Properties.Add([PSScriptProperty]::new(
                'Description', { @($this.GetHelpField("Description"))[0] -replace '^\s+' }
            ))

            $extCmd.PSObject.Properties.Add([PSScriptProperty]::new(
                'Synopsis', { @($this.GetHelpField("Synopsis"))[0] -replace '^\s+' }))

            $extCmd.PSObject.Properties.Add([PSScriptProperty]::new(
                'Examples', { $this.GetHelpField("Example") }))

            $extCmd.PSObject.Properties.Add([PSScriptProperty]::new(
                'Links', { $this.GetHelpField("Link") }))

            $extCmd.PSObject.Methods.Add([psscriptmethod]::new('Validate', {
                param(
                    # input being validated
                    [PSObject]$ValidateInput,
                    # If set, will require all [Validate] attributes to be valid.
                    # If not set, any input will be valid.
                    [switch]$AllValid
                )

                foreach ($attr in $this.ScriptBlock.Attributes) {
                    if ($attr -is [Management.Automation.ValidateScriptAttribute]) {
                        try {
                            $_ = $this = $psItem = $ValidateInput
                            $isValidInput = . $attr.ScriptBlock
                            if ($isValidInput -and -not $AllValid) { return $true}
                            if (-not $isValidInput -and $AllValid) {
                                if ($ErrorActionPreference -eq 'ignore') {
                                    return $false
                                } elseif ($AllValid) {
                                    throw "'$ValidateInput' is not a valid value."
                                }
                            }
                        } catch {
                            if ($AllValid) {
                                if ($ErrorActionPreference -eq 'ignore') {
                                    return $false
                                } else {
                                    throw
                                }
                            }
                        }
                    }
                    elseif ($attr -is [Management.Automation.ValidateSetAttribute]) {
                        if ($ValidateInput -notin $attr.ValidValues) {
                            if ($AllValid) {
                                if ($ErrorActionPreference -eq 'ignore') {
                                    return $false
                                } else {
                                    throw "'$ValidateInput' is not a valid value.  Valid values are '$(@($attr.ValidValues) -join "','")'"
                                }
                            }
                        } elseif (-not $AllValid) {
                            return $true
                        }
                    }
                    elseif ($attr -is [Management.Automation.ValidatePatternAttribute]) {
                        $matched = [Regex]::new($attr.RegexPattern, $attr.Options, [Timespan]::FromSeconds(1)).Match($ValidateInput)
                        if (-not $matched.Success) {
                            if ($allValid) {
                                if ($ErrorActionPreference -eq 'ignore') {
                                    return $false
                                } else {
                                    throw "'$ValidateInput' is not a valid value.  Valid values must match the pattern '$($attr.RegexPattern)'"
                                }
                            }
                        } elseif (-not $AllValid) {
                            return $true
                        }
                    }
                    elseif ($attr -is [Management.Automation.ValidateRangeAttribute]) {
                        if ($null -ne $attr.MinRange -and $validateInput -lt $attr.MinRange) {
                            if ($AllValid) {
                                if ($ErrorActionPreference -eq 'ignore') {
                                    return $false
                                } else {
                                    throw "'$ValidateInput' is below the minimum range [ $($attr.MinRange)-$($attr.MaxRange) ]"
                                }
                            }
                        }
                        elseif ($null -ne $attr.MaxRange -and $validateInput -gt $attr.MaxRange) {
                            if ($AllValid) {
                                if ($ErrorActionPreference -eq 'ignore') {
                                    return $false
                                } else {
                                    throw "'$ValidateInput' is above the maximum range [ $($attr.MinRange)-$($attr.MaxRange) ]"
                                }
                            }
                        }
                        elseif (-not $AllValid) {
                            return $true
                        }
                    }
                }

                if ($AllValid) {
                    return $true
                } else {
                    return $false
                }
            }))

            $extCmd.PSObject.Methods.Add([PSScriptMethod]::new('GetDynamicParameters', {
                param(
                [string]
                $ParameterSetName,

                [int]
                $PositionOffset,

                [switch]
                $NoMandatory,

                [string[]]
                $commandList
                )

                $ExtensionDynamicParameters = [Management.Automation.RuntimeDefinedParameterDictionary]::new()
                $Extension = $this

                :nextDynamicParameter foreach ($in in @(([Management.Automation.CommandMetaData]$Extension).Parameters.Keys)) {
                    $attrList = [Collections.Generic.List[Attribute]]::new()
                    $validCommandNames = @()
                    foreach ($attr in $extension.Parameters[$in].attributes) {
                        if ($attr -isnot [Management.Automation.ParameterAttribute]) {
                            # we can passthru any non-parameter attributes
                            $attrList.Add($attr)
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
                                    $defaultParamSetName =
                                        foreach ($extAttr in $Extension.ScriptBlock.Attributes) {
                                            if ($extAttr.DefaultParameterSetName) {
                                                $extAttr.DefaultParameterSetName
                                                break
                                            }
                                        }
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
                    $ExtensionDynamicParameters.Add($in, [Management.Automation.RuntimeDefinedParameter]::new(
                        $Extension.Parameters[$in].Name,
                        $Extension.Parameters[$in].ParameterType,
                        $attrList
                    ))
                }

                $ExtensionDynamicParameters

            }))


            $extCmd.PSObject.Methods.Add([PSScriptMethod]::new('IsParameterValid', {
                param([Parameter(Mandatory)]$ParameterName, [PSObject]$Value)

                if ($this.Parameters.Count -ge 0 -and 
                    $this.Parameters[$parameterName].Attributes
                ) {
                    foreach ($attr in $this.Parameters[$parameterName].Attributes) {
                        $_ = $value
                        if ($attr -is [Management.Automation.ValidateScriptAttribute]) {
                            $result = try { . $attr.ScriptBlock } catch { $null }
                            if ($result -ne $true) {
                                return $false
                            }
                        }
                        elseif ($attr -is [Management.Automation.ValidatePatternAttribute] -and 
                                (-not [Regex]::new($attr.RegexPattern, $attr.Options, '00:00:05').IsMatch($value))
                            ) {
                                return $false
                            }
                        elseif ($attr -is [Management.Automation.ValidateSetAttribute] -and 
                                $attr.ValidValues -notcontains $value) {
                                    return $false
                                }
                        elseif ($attr -is [Management.Automation.ValidateRangeAttribute] -and (
                            ($value -gt $attr.MaxRange) -or ($value -lt $attr.MinRange)
                        )) {
                            return $false
                        }
                    }
                }
                return $true
            }))

            $extCmd.PSObject.Methods.Add([PSScriptMethod]::new('CouldPipe', {
                param([PSObject]$InputObject)

                :nextParameterSet foreach ($paramSet in $this.ParameterSets) {
                    if ($ParameterSetName -and $paramSet.Name -ne $ParameterSetName) { continue }
                    $params = @{}
                    $mappedParams = [Ordered]@{} # Create a collection of mapped parameters
                    # Walk thru each parameter of this command
                    foreach ($myParam in $paramSet.Parameters) {
                        # If the parameter is ValueFromPipeline
                        if ($myParam.ValueFromPipeline) {
                            # and we have an input object
                            if ($null -ne $inputObject -and
                                (
                                    # of the exact type
                                    $myParam.ParameterType -eq $inputObject.GetType() -or
                                    # (or a subclass of that type)
                                    $inputObject.GetType().IsSubClassOf($myParam.ParameterType) -or
                                    # (or an inteface of that type)
                                    ($myParam.ParameterType.IsInterface -and $InputObject.GetType().GetInterface($myParam.ParameterType))
                                )
                            ) {
                                # then map the parameter.
                                $mappedParams[$myParam.Name] = $params[$myParam.Name] = $InputObject
                            }
                        }
                    }
                    # Check for parameter validity.
                    foreach ($mappedParamName in @($mappedParams.Keys)) {
                        if (-not $this.IsParameterValid($mappedParamName, $mappedParams[$mappedParamName])) {
                            $mappedParams.Remove($mappedParamName)
                        }
                    }
                    if ($mappedParams.Count -gt 0) {
                        return $mappedParams
                    }
                }
            }))            

            $extCmd.PSObject.Methods.Add([PSScriptMethod]::new('CouldRun', {
                param([Collections.IDictionary]$params, [string]$ParameterSetName)

                :nextParameterSet foreach ($paramSet in $this.ParameterSets) {
                    if ($ParameterSetName -and $paramSet.Name -ne $ParameterSetName) { continue }
                    $mappedParams = [Ordered]@{} # Create a collection of mapped parameters
                    $mandatories  =  # Walk thru each parameter of this command
                        @(foreach ($myParam in $paramSet.Parameters) {
                            if ($params.Contains($myParam.Name)) { # If this was in Params,
                                $mappedParams[$myParam.Name] = $params[$myParam.Name] # then map it.
                            } else {
                                foreach ($paramAlias in $myParam.Aliases) { # Otherwise, check the aliases
                                    if ($params.Contains($paramAlias)) { # and map it if the parameters had the alias.
                                        $mappedParams[$myParam.Name] = $params[$paramAlias]
                                        break
                                    }
                                }
                            }
                            if ($myParam.IsMandatory) { # If the parameter was mandatory,
                                $myParam.Name # keep track of it.
                            }
                        })

                    # Check for parameter validity.
                    foreach ($mappedParamName in @($mappedParams.Keys)) {
                        if (-not $this.IsParameterValid($mappedParamName, $mappedParams[$mappedParamName])) {
                            $mappedParams.Remove($mappedParamName)
                        }
                    }
                    
                    foreach ($mandatoryParam in $mandatories) { # Walk thru each mandatory parameter.
                        if (-not $mappedParams.Contains($mandatoryParam)) { # If it wasn't in the parameters.
                            continue nextParameterSet
                        }
                    }
                    return $mappedParams
                }
                return $false
            }))

            $extCmd.pstypenames.clear()
            if ($TranspilerTypeName) {
                $extCmd.pstypenames.add($TranspilerTypeName)
            } else {
                $extCmd.pstypenames.add('Extension')
            }

            $extCmd
        }
        function OutputExtension {
            begin {
                $allDynamicParameters = [Management.Automation.RuntimeDefinedParameterDictionary]::new()
            }
            process {
                $extCmd = $_

                # When we're outputting an extension, we start off assuming that it is valid.
                $IsValid = $true
                if ($ValidateInput) { # If we have a particular input we want to validate
                    try {
                        # Check if it is valid
                        if (-not $extCmd.Validate($ValidateInput, $AllValid)) {
                            $IsValid = $false # and then set IsValid if it is not.
                        }
                    } catch {
                        Write-Error $_    # If we encountered an exception, write it out
                        $IsValid = $false # and set is $IsValid to false.
                    }
                }

                
                # If we're requesting dynamic parameters (and the extension is valid)
                if ($IsValid -and 
                    ($DynamicParameter -or $DynamicParameterSetName -or $DynamicParameterPositionOffset -or $NoMandatoryDynamicParameter)) {
                    # Get what the dynamic parameters of the extension would be.
                    $extensionParams = $extCmd.GetDynamicParameters($DynamicParameterSetName, 
                        $DynamicParameterPositionOffset, 
                        $NoMandatoryDynamicParameter, $CommandName)
                    
                    # Then, walk over each extension parameter.
                    foreach ($kv in $extensionParams.GetEnumerator()) {
                        # If the $CommandExtended had a built-in parameter, we cannot override it, so skip it.
                        if ($commandExtended -and ([Management.Automation.CommandMetaData]$commandExtended).Parameters.$($kv.Key)) {
                            continue
                        }

                        # If already have this dynamic parameter
                        if ($allDynamicParameters.ContainsKey($kv.Key)) {

                            # check it's type.
                            if ($kv.Value.ParameterType -ne $allDynamicParameters[$kv.Key].ParameterType) {
                                # If the types are different, make it a PSObject (so it could be either).
                                Write-Verbose "Extension '$extCmd' Parameter '$($kv.Key)' Type Conflict, making type PSObject"
                                $allDynamicParameters[$kv.Key].ParameterType = [PSObject]
                            }


                            foreach ($attr in $kv.Value.Attributes) {
                                if ($allDynamicParameters[$kv.Key].Attributes.Contains($attr)) {
                                    continue
                                }
                                $allDynamicParameters[$kv.Key].Attributes.Add($attr)
                            }
                        } else {
                            $allDynamicParameters[$kv.Key] = $kv.Value
                        }
                    }
                }
                elseif ($IsValid -and ($CouldPipe -or $CouldRun)) {
                    if (-not $extCmd) { return }

                    $extensionParams = [Ordered]@{}
                    $pipelineParams = @()
                    if ($CouldPipe) {
                        $couldPipeExt = $extCmd.CouldPipe($CouldPipe)
                        if (-not $couldPipeExt) { return }
                        $pipelineParams += $couldPipeExt.Keys
                        if (-not $CouldRun) {                            
                            $extensionParams += $couldPipeExt
                        } else {
                            foreach ($kv in $couldPipeExt.GetEnumerator()) {
                                $Parameter[$kv.Key] = $kv.Value
                            }
                        }
                    }
                    if ($CouldRun) {
                        $couldRunExt = $extCmd.CouldRun($Parameter, $ParameterSetName)
                        if (-not $couldRunExt) { return }
                        $extensionParams += $couldRunExt
                    }
                
                    [PSCustomObject][Ordered]@{
                        ExtensionCommand = $extCmd
                        CommandName = $CommandName
                        ExtensionInputObject = if ($CouldPipe) { $CouldPipe } else { $null }                        
                        ExtensionParameter   = $extensionParams
                        PipelineParameters   = $pipelineParams
                    }
                }
                elseif ($IsValid -and $SteppablePipeline) {
                    if (-not $extCmd) { return }
                    if ($Parameter) {
                        $couldRunExt = $extCmd.CouldRun($Parameter, $ParameterSetName)
                        if (-not $couldRunExt) {
                            $sb = {& $extCmd }
                            $sb.GetSteppablePipeline() |
                                Add-Member NoteProperty ExtensionCommand $extCmd -Force -PassThru |
                                Add-Member NoteProperty ExtensionParameters $couldRunExt -Force -PassThru |
                                Add-Member NoteProperty ExtensionScriptBlock $sb -Force -PassThru
                        } else {
                            $sb = {& $extCmd @couldRunExt}
                            $sb.GetSteppablePipeline() |
                                Add-Member NoteProperty ExtensionCommand $extCmd -Force -PassThru |
                                Add-Member NoteProperty ExtensionParameters $couldRunExt -Force -PassThru |
                                Add-Member NoteProperty ExtensionScriptBlock $sb -Force -PassThru
                        }
                    } else {
                        $sb = {& $extCmd }
                        $sb.GetSteppablePipeline() |
                            Add-Member NoteProperty ExtensionCommand $extCmd -Force -PassThru |
                            Add-Member NoteProperty ExtensionParameters @{} -Force -PassThru |
                            Add-Member NoteProperty ExtensionScriptBlock $sb -Force -PassThru
                    }
                }
                elseif ($IsValid -and $Run) {
                    if (-not $extCmd) { return }
                    $couldRunExt = $extCmd.CouldRun($Parameter, $ParameterSetName)
                    if (-not $couldRunExt) { return }
                    if ($extCmd.InheritanceLevel -eq 'InheritedReadOnly') { return }
                    if ($Stream) {
                        & $extCmd @couldRunExt
                    } else {
                        [PSCustomObject][Ordered]@{
                            CommandName      = $CommandName
                            ExtensionCommand = $extCmd
                            ExtensionOutput  = & $extCmd @couldRunExt
                            Done             = $extCmd.InheritanceLevel -eq 'NotInherited'
                        }
                    }
                    return
                }
                elseif ($IsValid -and ($Help -or $FullHelp -or $Example -or $ParameterHelp)) {
                    $getHelpSplat = @{}
                    if ($FullHelp) {
                        $getHelpSplat["Full"] = $true
                    }
                    if ($Example) {
                        $getHelpSplat["Example"] = $true
                    }
                    if ($ParameterHelp) {
                        $getHelpSplat["ParameterHelp"] = $ParameterHelp
                    }

                    if ($extCmd -is [Management.Automation.ExternalScriptInfo]) {
                        Get-Help $extCmd.Source @getHelpSplat
                    } elseif ($extCmd -is [Management.Automation.FunctionInfo]) {
                        Get-Help $extCmd @getHelpSplat
                    }
                }
                elseif ($IsValid) {
                    return $extCmd
                }
            }
            end {
                if ($DynamicParameter) {
                    return $allDynamicParameters
                }
            }
        }
        #endregion Define Inner Functions


        $extensionFullRegex =
            [Regex]::New($(
                if ($TranspilerModule) {
                    "\.(?>$(@(@($TranspilerModule) + $TranspilerModuleAlias) -join '|'))\." + "(?>$($TranspilerPattern -join '|'))"
                } else {
                    "(?>$($TranspilerPattern -join '|'))"
                }
            ), 'IgnoreCase,IgnorePatternWhitespace', '00:00:01')

        #region Find Extensions
        $loadedModules = @(Get-Module)
        $myInv = $MyInvocation
        $myModuleName = if ($TranspilerModule) { $TranspilerModule } else { $MyInvocation.MyCommand.Module.Name }
        if ($myInv.MyCommand.Module -and $loadedModules -notcontains $myInv.MyCommand.Module) {
            $loadedModules = @($myInv.MyCommand.Module) + $loadedModules
        }
        $getCmd    = $ExecutionContext.SessionState.InvokeCommand.GetCommand

        if ($Force) {
            $script:Transpilers = $null
        }
        if (-not $script:Transpilers)
        {
            $script:Transpilers =
                @(
                #region Find Transpiler in Loaded Modules
                foreach ($loadedModule in $loadedModules) { # Walk over all modules.
                    if ( # If the module has PrivateData keyed to this module
                        $loadedModule.PrivateData.$myModuleName
                    ) {
                        # Determine the root of the module with private data.
                        $thisModuleRoot = [IO.Path]::GetDirectoryName($loadedModule.Path)
                        # and get the extension data
                        $extensionData = $loadedModule.PrivateData.$myModuleName
                        if ($extensionData -is [Hashtable]) { # If it was a hashtable
                            foreach ($ed in $extensionData.GetEnumerator()) { # walk each key

                                $extensionCmd =
                                    if ($ed.Value -like '*.ps1') { # If the key was a .ps1 file
                                        $getCmd.Invoke( # treat it as a relative path to the .ps1
                                            [IO.Path]::Combine($thisModuleRoot, $ed.Value),
                                            'ExternalScript'
                                        )
                                    } else { # Otherwise, treat it as the name of an exported command.
                                        $loadedModule.ExportedCommands[$ed.Value]
                                    }
                                if ($extensionCmd) { # If we've found a valid extension command
                                    $extensionCmd | ConvertToExtension # return it as an extension.
                                }
                            }
                        }
                    }
                    elseif ($loadedModule.PrivateData.PSData.Tags -contains $myModuleName -or $loadedModule.Name -eq $myModuleName) {
                        $loadedModule |
                            Split-Path |
                            Get-ChildItem -Recurse |
                            Where-Object { $_.Name -Match $extensionFullRegex } |
                            ConvertToExtension
                    }
                }
                #endregion Find Transpiler in Loaded Modules
                )
        }
        #endregion Find Extensions
    }

    process {

        if ($TranspilerPath) {
            Get-ChildItem -Recurse -Path $TranspilerPath |
                Where-Object { $_.Name -Match $extensionFullRegex } |
                ConvertToExtension |
                . WhereExtends $CommandName |
                #region Install-Piecemeal -WhereObject
                # This section can be updated by using Install-Piecemeal -WhereObject
                #endregion Install-Piecemeal -WhereObject
                Sort-Object Rank, Name |
                OutputExtension
                #region Install-Piecemeal -ForeachObject
                # This section can be updated by using Install-Piecemeal -ForeachObject
                #endregion Install-Piecemeal -ForeachObject
        } else {
            $script:Transpilers |
                . WhereExtends $CommandName |
                Sort-Object Rank, Name |
                OutputExtension
        }
    }
}
#endregion Piecemeal [ 0.3.2 ] : Easy Extensible Plugins for PowerShell

