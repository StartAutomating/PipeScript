<#
.SYNOPSIS
    Finds extensions for a module
.DESCRIPTION
    Finds extended commands for a module. 
.EXAMPLE
    (Get-Module PipeScript).FindExtensions((Get-Module PipeScript | Split-Path))
#>
param()

$targetModules = @()
$targetPaths = @()
$loadedModules = Get-Module
foreach ($arg in $args) {
    if ($arg -is [Management.Automation.PSModuleInfo]) {
        $targetModules += $arg
    }
    elseif ($arg -is [IO.FileInfo] -or $arg -is [IO.DirectoryInfo]) {
        $targetPaths += $arg
    } 
    elseif ($arg -is [Management.Automation.PathInfo]) {
        $targetPaths += "$arg"
    }
    elseif ($arg -is [string]) {
        $argIsModule = 
            foreach ($module in $loadedModules) { if ($module.Name -like $arg) { $module}}
        if ($argIsModule) {
            $targetModules += $argIsModule
        } elseif (Test-Path $arg) {
            $targetPaths += $arg
        }
        
    }
}

if (-not $targetModules) { $targetModules = $this}
$Splat = @{}
if ($targetPaths) {
    $Splat.FilePath = $targetPaths
}
foreach ($module in $targetModules) {
    # Aspect.ModuleExtendedCommand
    & { 
    
        <#
        .SYNOPSIS
            Returns a module's extended commands
        .DESCRIPTION
            Returns the commands or scripts in a module that match the module command pattern.
    
            Each returned script will be decorated with the typename(s) that match,
            so that the extended commands can be augmented by the extended types system.
        .LINK
            Aspect.ModuleExtensionPattern
        .EXAMPLE
            Aspect.ModuleExtensionCommand -Module PipeScript # Should -BeOfType ([Management.Automation.CommandInfo])
        #>
        [Alias('Aspect.ModuleExtendedCommand')]
        param(
        # The name of a module, or a module info object.
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [ValidateScript({
        $validTypeList = [System.String],[System.Management.Automation.PSModuleInfo]
        
        $thisType = $_.GetType()
        $IsTypeOk =
            $(@( foreach ($validType in $validTypeList) {
                if ($_ -as $validType) {
                    $true;break
                }
            }))
        
        if (-not $isTypeOk) {
            throw "Unexpected type '$(@($thisType)[0])'.  Must be 'string','psmoduleinfo'."
        }
        return $true
        })]
        
        $Module,
        
        # A list of commands.
        # If this is provided, each command that is a valid extension will be returned.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Management.Automation.CommandInfo[]]
        $Commands,
    
        # The suffix to apply to each named capture.
        # Defaults to '_Command'
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $Suffix = '_Command',
    
        # The prefix to apply to each named capture. 
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $Prefix,
    
        # The file path(s).  If provided, will look for commands within these paths.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Fullname')]    
        $FilePath,
    
        # The PowerShell command type.  If this is provided, will only get commands of this type.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Management.Automation.CommandTypes]
        $CommandType,
    
        # The base PSTypeName(s).
        # If provided, any commands that match the pattern will apply these typenames, too.
        [string[]]
        $PSTypeName
        )
    
        process {        
            if ($Module -is [string]) {
                $Module = Get-Module $Module
            }
            $ModuleInfo = $module
    
            if (-not $ModuleInfo) { return }
            
            $ModuleCommandPattern = # Aspect.ModuleExtensionPattern
                                    & { 
                                    
                                        <#
                                        .SYNOPSIS
                                            Outputs a module's extension pattern
                                        .DESCRIPTION
                                            Outputs a regular expression that will match any possible pattern.
                                        .EXAMPLE
                                            Aspect.ModuleCommandPattern -Module PipeScript # Should -BeOfType ([Regex])
                                        #>
                                        [Alias('Aspect.ModuleCommandPattern')]
                                        param(
                                        # The name of a module, or a module info object.
                                        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
                                        [ValidateScript({
                                        $validTypeList = [System.String],[System.Management.Automation.PSModuleInfo]
                                        
                                        $thisType = $_.GetType()
                                        $IsTypeOk =
                                            $(@( foreach ($validType in $validTypeList) {
                                                if ($_ -as $validType) {
                                                    $true;break
                                                }
                                            }))
                                        
                                        if (-not $isTypeOk) {
                                            throw "Unexpected type '$(@($thisType)[0])'.  Must be 'string','psmoduleinfo'."
                                        }
                                        return $true
                                        })]
                                        
                                        $Module,
                                    
                                        # The suffix to apply to each named capture.
                                        # Defaults to '_Command'
                                        [Parameter(ValueFromPipelineByPropertyName)]
                                        [string]
                                        $Suffix = '_Command',
                                    
                                        # The prefix to apply to each named capture. 
                                        [Parameter(ValueFromPipelineByPropertyName)]
                                        [string]
                                        $Prefix
                                        )
                                    
                                        process {
                                            if ($Module -is [string]) {
                                                $Module = Get-Module $Module
                                            }
                                            $ModuleInfo = $module
                                    
                                    
                                            #region Search for Module Extension Types
                                            if (-not $ModuleInfo) { return }
                                            $ModuleExtensionTypes = # Aspect.ModuleExtensionTypes
                                                                    & { 
                                                                    
                                                                        <#
                                                                        .SYNOPSIS
                                                                            Outputs a module's extension types
                                                                        .DESCRIPTION
                                                                            Outputs the extension types defined in a module's manifest.
                                                                        .EXAMPLE
                                                                            # Outputs a PSObject with information about extension command types.
                                                                            
                                                                            # The two primary pieces of information are the `.Name` and `.Pattern`.
                                                                            Aspect.ModuleExtensionType -Module PipeScript # Should -BeOfType ([PSObject])
                                                                        #>
                                                                        [Alias('Aspect.ModuleCommandTypes','Aspect.ModuleCommandType','Aspect.ModuleExtensionTypes')]
                                                                        param(
                                                                        # The name of a module, or a module info object.
                                                                        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
                                                                        [ValidateScript({
                                                                        $validTypeList = [System.String],[System.Management.Automation.PSModuleInfo]
                                                                        
                                                                        $thisType = $_.GetType()
                                                                        $IsTypeOk =
                                                                            $(@( foreach ($validType in $validTypeList) {
                                                                                if ($_ -as $validType) {
                                                                                    $true;break
                                                                                }
                                                                            }))
                                                                        
                                                                        if (-not $isTypeOk) {
                                                                            throw "Unexpected type '$(@($thisType)[0])'.  Must be 'string','psmoduleinfo'."
                                                                        }
                                                                        return $true
                                                                        })]
                                                                        
                                                                        $Module
                                                                        )
                                                                    
                                                                        begin {
                                                                            $ExtensionCollectionNames = 
                                                                                "Extension", "Command", "Cmdlet", "Function", "Alias", "Script", "Application", "File","Configuration"
                                                                            $ExtensionCollectionNames = @($ExtensionCollectionNames -replace '.+$','${0}Type') + @($ExtensionCollectionNames -replace '.+$','${0}Types')
                                                                        }
                                                                    
                                                                        process {
                                                                            #region Resolve Module Info
                                                                            if ($Module -is [string]) {
                                                                                $Module = Get-Module $Module
                                                                            }
                                                                            $ModuleInfo = $module                
                                                                            if (-not $ModuleInfo) { return }
                                                                            #endregion Resolve Module Info
                                                                    
                                                                            #region Check Cache and Hopefully Return
                                                                            if (-not $script:ModuleExtensionTypeCache) {
                                                                                $script:ModuleExtensionTypeCache = @{}
                                                                            }
                                                                            
                                                                            if ($script:ModuleExtensionTypeCache[$ModuleInfo]) {
                                                                                return $script:ModuleExtensionTypeCache[$ModuleInfo]
                                                                            }
                                                                            #endregion Check Cache and Hopefully Return
                                                                    
                                                                            #region Find Extension Types
                                                                            $modulePrivateData  = $ModuleInfo.PrivateData
                                                                    
                                                                            $SortedExtensionTypes = [Ordered]@{}
                                                                            foreach ($TypeOfExtensionCollection in $ExtensionCollectionNames) {
                                                                                $moduleExtensionTypes = 
                                                                                    if ($modulePrivateData.$TypeOfExtensionCollection) {
                                                                                        $modulePrivateData.$TypeOfExtensionCollection
                                                                                    } elseif ($modulePrivateData.PSData.$TypeOfExtensionCollection) {
                                                                                        $modulePrivateData.PSData.$TypeOfExtensionCollection
                                                                                    } else {
                                                                                        $null
                                                                                    }
                                                                    
                                                                                if (-not $moduleExtensionTypes) { continue } 
                                                                    
                                                                                foreach ($commandType in @($ModuleExtensionTypes.GetEnumerator() | Sort-Object Key)) {
                                                                                    if ($commandType.Value -is [Collections.IDictionary]) {
                                                                                        if (-not $commandType.Value.Name) {
                                                                                            $commandType.Value["Name"] = $commandType.Key
                                                                                        }
                                                                                        if (-not $commandType.Value.PSTypeName) {
                                                                                            $commandType.Value["PSTypeName"] = "$($module.Name).ExtensionCommandType"
                                                                                        }
                                                                                        $SortedExtensionTypes[$commandType.Name] = $commandType.Value
                                                                                    } else {
                                                                                        $SortedExtensionTypes[$commandType.Name] = [Ordered]@{
                                                                                            PSTypeName = "$($module.Name).ExtensionCommandType"
                                                                                            Name    = $commandType.Key
                                                                                            Pattern = $commandType.Value
                                                                                        }
                                                                                    }
                                                                                    if ($TypeOfExtensionCollection -notmatch '(?>Extension|Command|Cmdlet)') {
                                                                                        $SortedExtensionTypes[$commandType.Name].CommandType = $TypeOfExtensionCollection -replace 'Type(?:s)?$'
                                                                                    } elseif ($TypeOfExtensionCollection -match 'Cmdlet') {
                                                                                        $SortedExtensionTypes[$commandType.Name].CommandType = "(?>Alias|Function|Filter|Cmdlet)"
                                                                                    }
                                                                                }
                                                                            }
                                                                            
                                                                            $SortedExtensionTypes.PSTypeName="$($Module.Name).ExtensionCommandTypes"
                                                                            
                                                                            $script:ModuleExtensionTypeCache[$ModuleInfo] = [PSCustomObject]$SortedExtensionTypes
                                                                            $script:ModuleExtensionTypeCache[$ModuleInfo]
                                                                            #endregion Find Extension Types
                                                                    
                                                                        }    
                                                                    
                                                                     } -Module $moduleInfo
                                    
                                            
                                            if (-not $ModuleExtensionTypes) { return }
                                                
                                            # With some clever understanding of Regular expressions, we can make match any/all of our potential command types.
                                            # Essentially: Regular Expressions can look ahead (matching without changing the position), and be optional.
                                            # So we can say "any/all" by making a series of optional lookaheads.
                                            
                                            # We'll go thru each pattern in order
                                            $combinedRegex = @(foreach ($categoryExtensionTypeInfo in @($ModuleExtensionTypes.psobject.properties)) {
                                                $categoryPattern = $categoryExtensionTypeInfo.Value.Pattern                
                                                # ( and skip anyone that does not have a pattern)
                                                if (-not $categoryPattern) { continue } 
                                    
                                                '(?=' + # Start a lookahead
                                                    '.{0,}' + # match any or no characters
                                                    # followed by the command pattern
                                                    "(?<$Prefix$($categoryExtensionTypeInfo.Name -replace '\p{P}', '_')$Suffix>$categoryPattern)" +
                                                    ')?' # made optional                            
                                            }) -join [Environment]::NewLine
                                    
                                            # Now that we've combined the whole thing, make it a Regex and output it.        
                                            [Regex]::new("$combinedRegex", 'IgnoreCase,IgnorePatternWhitespace','00:00:01')
                                        }
                                    
                                     } $ModuleInfo -Prefix $prefix -Suffix $Suffix
            $ModuleCommandTypes   = # Aspect.ModuleExtensionType
                                    & { 
                                    
                                        <#
                                        .SYNOPSIS
                                            Outputs a module's extension types
                                        .DESCRIPTION
                                            Outputs the extension types defined in a module's manifest.
                                        .EXAMPLE
                                            # Outputs a PSObject with information about extension command types.
                                            
                                            # The two primary pieces of information are the `.Name` and `.Pattern`.
                                            Aspect.ModuleExtensionType -Module PipeScript # Should -BeOfType ([PSObject])
                                        #>
                                        [Alias('Aspect.ModuleCommandTypes','Aspect.ModuleCommandType','Aspect.ModuleExtensionTypes')]
                                        param(
                                        # The name of a module, or a module info object.
                                        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
                                        [ValidateScript({
                                        $validTypeList = [System.String],[System.Management.Automation.PSModuleInfo]
                                        
                                        $thisType = $_.GetType()
                                        $IsTypeOk =
                                            $(@( foreach ($validType in $validTypeList) {
                                                if ($_ -as $validType) {
                                                    $true;break
                                                }
                                            }))
                                        
                                        if (-not $isTypeOk) {
                                            throw "Unexpected type '$(@($thisType)[0])'.  Must be 'string','psmoduleinfo'."
                                        }
                                        return $true
                                        })]
                                        
                                        $Module
                                        )
                                    
                                        begin {
                                            $ExtensionCollectionNames = 
                                                "Extension", "Command", "Cmdlet", "Function", "Alias", "Script", "Application", "File","Configuration"
                                            $ExtensionCollectionNames = @($ExtensionCollectionNames -replace '.+$','${0}Type') + @($ExtensionCollectionNames -replace '.+$','${0}Types')
                                        }
                                    
                                        process {
                                            #region Resolve Module Info
                                            if ($Module -is [string]) {
                                                $Module = Get-Module $Module
                                            }
                                            $ModuleInfo = $module                
                                            if (-not $ModuleInfo) { return }
                                            #endregion Resolve Module Info
                                    
                                            #region Check Cache and Hopefully Return
                                            if (-not $script:ModuleExtensionTypeCache) {
                                                $script:ModuleExtensionTypeCache = @{}
                                            }
                                            
                                            if ($script:ModuleExtensionTypeCache[$ModuleInfo]) {
                                                return $script:ModuleExtensionTypeCache[$ModuleInfo]
                                            }
                                            #endregion Check Cache and Hopefully Return
                                    
                                            #region Find Extension Types
                                            $modulePrivateData  = $ModuleInfo.PrivateData
                                    
                                            $SortedExtensionTypes = [Ordered]@{}
                                            foreach ($TypeOfExtensionCollection in $ExtensionCollectionNames) {
                                                $moduleExtensionTypes = 
                                                    if ($modulePrivateData.$TypeOfExtensionCollection) {
                                                        $modulePrivateData.$TypeOfExtensionCollection
                                                    } elseif ($modulePrivateData.PSData.$TypeOfExtensionCollection) {
                                                        $modulePrivateData.PSData.$TypeOfExtensionCollection
                                                    } else {
                                                        $null
                                                    }
                                    
                                                if (-not $moduleExtensionTypes) { continue } 
                                    
                                                foreach ($commandType in @($ModuleExtensionTypes.GetEnumerator() | Sort-Object Key)) {
                                                    if ($commandType.Value -is [Collections.IDictionary]) {
                                                        if (-not $commandType.Value.Name) {
                                                            $commandType.Value["Name"] = $commandType.Key
                                                        }
                                                        if (-not $commandType.Value.PSTypeName) {
                                                            $commandType.Value["PSTypeName"] = "$($module.Name).ExtensionCommandType"
                                                        }
                                                        $SortedExtensionTypes[$commandType.Name] = $commandType.Value
                                                    } else {
                                                        $SortedExtensionTypes[$commandType.Name] = [Ordered]@{
                                                            PSTypeName = "$($module.Name).ExtensionCommandType"
                                                            Name    = $commandType.Key
                                                            Pattern = $commandType.Value
                                                        }
                                                    }
                                                    if ($TypeOfExtensionCollection -notmatch '(?>Extension|Command|Cmdlet)') {
                                                        $SortedExtensionTypes[$commandType.Name].CommandType = $TypeOfExtensionCollection -replace 'Type(?:s)?$'
                                                    } elseif ($TypeOfExtensionCollection -match 'Cmdlet') {
                                                        $SortedExtensionTypes[$commandType.Name].CommandType = "(?>Alias|Function|Filter|Cmdlet)"
                                                    }
                                                }
                                            }
                                            
                                            $SortedExtensionTypes.PSTypeName="$($Module.Name).ExtensionCommandTypes"
                                            
                                            $script:ModuleExtensionTypeCache[$ModuleInfo] = [PSCustomObject]$SortedExtensionTypes
                                            $script:ModuleExtensionTypeCache[$ModuleInfo]
                                            #endregion Find Extension Types
                                    
                                        }    
                                    
                                     } $ModuleInfo
            
            $commands    =
                @(
                if ($PSBoundParameters['Commands']) {
                    $commands
                }
                elseif ($PSBoundParameters['FilePath']) {
                    if (-not $commandType) {
                        $commandType = 'Application,ExternalScript'
                    }
                    
                    $shouldRecurse = $($PSBoundParameters['FilePath'] -notmatch '^\.\\') -as [bool]
                        
                    foreach ($file in Get-ChildItem -File -Path $PSBoundParameters['FilePath'] -Recurse:$shouldRecurse ) {
                        $ExecutionContext.SessionState.InvokeCommand.GetCommand($file.FullName, $commandType)
                    }
                } else {
                    if (-not $CommandType) {
                        $commandType = 'Function,Alias,Filter,Cmdlet'
                    }
                    $ExecutionContext.SessionState.InvokeCommand.GetCommands('*', $commandType, $true)
                })
    
            :nextCommand foreach ($cmd in $commands) {            
                $matched = $ModuleCommandPattern.Match("$cmd")
                if (-not $matched.Success) { continue }
                $NamedGroupMatch = $false
                :nextCommandType foreach ($group in $matched.Groups) {
                    if (-not $group.Success) { continue }
                    if ($null -ne ($group.Name -as [int])) { continue }                
                    $CommandTypeName     = $group.Name.Replace('_','.')
                    $ThisCommandsType    = $ModuleCommandTypes.($group.Name -replace "^$prefix" -replace "$suffix$")
                    if ($ThisCommandsType) {
                        $ThisTypeFilter = @($ThisCommandsType.CommandType,$ThisCommandsType.CommandTypes -ne $null)[0]
                        if ($ThisTypeFilter -and ($cmd.CommandType -notmatch $ThisTypeFilter)) {
                            continue nextCommandType
                        }
                        $ThisExcludeFilter = @($ThisCommandsType.ExcludeCommandType,$ThisCommandsType.ExcludeCommandTypes -ne $null)[0]
                        if ($ThisExcludeFilter -and ($cmd.CommandType -match $ThisExcludeFilter)) {
                            continue nextCommandType
                        }
                    }
                    $NamedGroupMatch     = $true
                    if ($PSTypeName) {
                        foreach ($psuedoType in $PSTypeName) {
                            if ($cmd.pstypenames -notcontains $psuedoType) {
                                $cmd.pstypenames.insert(0, $psuedoType)        
                            }
                        }
                    }
                    if ($cmd.pstypenames -notcontains $CommandTypeName) {
                        $cmd.pstypenames.insert(0, $CommandTypeName)
                    }
                }
                if ($NamedGroupMatch) {
                    $cmd
                }
            }
        }
    
     } -Module $module @Splat
}
