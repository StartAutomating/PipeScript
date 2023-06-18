
function Aspect.ModuleCommandType {
    <#
    .SYNOPSIS
        Outputs a module's command types
    .DESCRIPTION
        Outputs the command types defined in a module's manifest.
    .EXAMPLE
        # Outputs a series of PSObjects with information about command types.
        # The two primary pieces of information are the `.Name` and `.Pattern`.
        Aspect.ModuleCommandType -Module PipeScript # Should -BeOfType ([PSObject])
    #>
    [Alias('Aspect.ModuleCommandTypes')]
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
    process {
        if ($Module -is [string]) {
            $Module = Get-Module $Module
        }
        $ModuleInfo = $module
        
        #region Search for Module Command Types
        if (-not $ModuleInfo) { return }
        $ModuleCommandTypes = 
            @($ModuleInfo.PrivateData.CommandType,
            $ModuleInfo.PrivateData.CommandTypes,
            $ModuleInfo.PrivateData.PSData.CommandType,
            $ModuleInfo.PrivateData.PSData.CommandType -ne $null)[0]
        
        if (-not $ModuleCommandTypes) { return }
            
        foreach ($commandType in @($ModuleCommandTypes.GetEnumerator())) {
            if ($commandType.Value -is [Collections.IDictionary]) {
                if (-not $commandType.Value.Name) {
                    $commandType.Value["Name"] = $commandType.Key
                }
                [PSCustomObject]$commandType.Value
                
            } else {
                [PSCustomObject]@{
                    Name    = $commandType.Key
                    Pattern = $commandType.Value
                }
            }   
        }
    }    
}



function Aspect.ModuleCommandPattern {
    <#
    .SYNOPSIS
        Outputs a module's command pattern
    .DESCRIPTION
        Outputs a regular expression that can be used to match any command pattern.
    .EXAMPLE
        Aspect.ModuleCommandPattern -Module PipeScript # Should -BeOfType ([Regex])
    #>
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
        #region Search for Module Command Types
        if (-not $ModuleInfo) { return }
        $ModuleCommandTypes = 
            @($ModuleInfo.PrivateData.CommandType,
            $ModuleInfo.PrivateData.CommandTypes,
            $ModuleInfo.PrivateData.PSData.CommandType,
            $ModuleInfo.PrivateData.PSData.CommandType -ne $null)[0]
        
        if (-not $ModuleCommandTypes) { return }
            
        $combinedRegex = @(foreach ($categoryKeyValue in $ModuleCommandTypes.GetEnumerator()) {
            $categoryPattern = 
                if ($categoryKeyValue.Value -is [string]) {
                    $categoryKeyValue.Value
                } else {
                    $categoryKeyValue.Value.Pattern
                }
            if (-not $categoryPattern) { continue }
            "(?<$Prefix$($categoryKeyValue.Key -replace '\p{P}', '_')$Suffix>$categoryPattern)"
        }) -join ([Environment]::NewLine + '|' + [Environment]::NewLine)
        [Regex]::new("($combinedRegex)", 'IgnoreCase,IgnorePatternWhitespace','00:00:01')
    }
}



function Aspect.ModuleExtendedCommand {
    <#
    .SYNOPSIS
        Returns a module's extended commands
    .DESCRIPTION
        Returns the commands or scripts in a module that match the module command pattern.
        Each returned script will be decorated with the typename(s) that match,
        so that the extended commands can be augmented by the extended types system.
    .LINK
        Aspect.ModuleCommandPattern
    .EXAMPLE
        Aspect.ModuleExtendedCommand -Module PipeScript # Should -BeOfType ([Management.Automation.CommandInfo])
    #>
    [Alias('Aspect.ModuleExtensionCommand')]
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
    $Prefix,
    # The file path(s).  If provided, will look for commands within these paths.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Fullname')]    
    $FilePath,
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
        
        $CommandPattern = # Aspect.ModuleCommandPattern
                          & { 
                              <#
                              .SYNOPSIS
                                  Outputs a module's command pattern
                              .DESCRIPTION
                                  Outputs a regular expression that can be used to match any command pattern.
                              .EXAMPLE
                                  Aspect.ModuleCommandPattern -Module PipeScript # Should -BeOfType ([Regex])
                              #>
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
                                  #region Search for Module Command Types
                                  if (-not $ModuleInfo) { return }
                                  $ModuleCommandTypes = 
                                      @($ModuleInfo.PrivateData.CommandType,
                                      $ModuleInfo.PrivateData.CommandTypes,
                                      $ModuleInfo.PrivateData.PSData.CommandType,
                                      $ModuleInfo.PrivateData.PSData.CommandType -ne $null)[0]
                                  
                                  if (-not $ModuleCommandTypes) { return }
                                      
                                  $combinedRegex = @(foreach ($categoryKeyValue in $ModuleCommandTypes.GetEnumerator()) {
                                      $categoryPattern = 
                                          if ($categoryKeyValue.Value -is [string]) {
                                              $categoryKeyValue.Value
                                          } else {
                                              $categoryKeyValue.Value.Pattern
                                          }
                                      if (-not $categoryPattern) { continue }
                                      "(?<$Prefix$($categoryKeyValue.Key -replace '\p{P}', '_')$Suffix>$categoryPattern)"
                                  }) -join ([Environment]::NewLine + '|' + [Environment]::NewLine)
                                  [Regex]::new("($combinedRegex)", 'IgnoreCase,IgnorePatternWhitespace','00:00:01')
                              }
                           } $ModuleInfo -Prefix $prefix -Suffix $Suffix
        if ($PSBoundParameters['FilePath']) {
            $(
                    # Collect all items into an input collection
                    $inputCollection = @($executionContext.SessionState.InvokeCommand.GetCommands('*','Script',$true)
               ($FilePath |
                & { process {
                    $inObj = $_
                    if ($inObj -is [Management.Automation.CommandInfo]) {
                        $inObj
                    }
                    elseif ($inObj -is [IO.FileInfo] -and $inObj.Extension -eq '.ps1') {
                        $ExecutionContext.SessionState.InvokeCommand.GetCommand($inObj.Fullname, 'ExternalScript')
                    }
                    elseif ($inObj -is [string] -or $inObj -is [Management.Automation.PathInfo]) {
                        $resolvedPath = $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($inObj)
                        if ($resolvedPath) {
                            $pathItem = Get-item -LiteralPath $resolvedPath
                            if ($pathItem -is [IO.FileInfo] -and $pathItem.Extension -eq '.ps1') {
                                $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'ExternalScript')
                            } else {                    
                                foreach ($pathItem in @(Get-ChildItem -LiteralPath $pathItem -File -Recurse)) {
                                    if ($pathItem.Extension -eq '.ps1') {
                                        $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'ExternalScript')
                                    }
                                }
                            }
                        }            
                    }
                } }
            ))
            # Walk over each item in the filtered collection
            foreach ($item in $inputCollection) {
                # we set $this, $psItem, and $_ for ease-of-use.
                $this = $_ = $psItem = $item
                
                            $cmd = $_                
                            $matched = $CommandPattern.Match("$cmd")
                            if (-not $matched.Success) { continue }
                            foreach ($group in $matched.Groups) {
                                if (-not $group.Success) { continue }
                                if ($null -ne ($group.Name -as [int])) { continue }
                                $groupName = $group.Name.Replace('_','.')
                                if ($PSTypeName) {
                                    foreach ($psuedoType in $PSTypeName) {
                                        if ($cmd.pstypenames -notcontains $psuedoType) {
                                            $cmd.pstypenames.insert(0, $psuedoType)        
                                        }
                                    }
                                }
                                if ($cmd.pstypenames -notcontains $groupName) {
                                    $cmd.pstypenames.insert(0, $groupName)
                                }
                            }
                            $cmd    
                         
            }   
            )
        }
        else {
            $(
                    # Collect all items into an input collection
                    $inputCollection = @($executionContext.SessionState.InvokeCommand.GetCommands('*','Alias, Function, Cmdlet',$true))
            # Walk over each item in the filtered collection
            foreach ($item in $inputCollection) {
                # we set $this, $psItem, and $_ for ease-of-use.
                $this = $_ = $psItem = $item
                
                            $cmd = $_                
                            $matched = $CommandPattern.Match("$cmd")
                            if (-not $matched.Success) { continue }
                            foreach ($group in $matched.Groups) {
                                if (-not $group.Success) { continue }
                                if ($null -ne ($group.Name -as [int])) { continue }
                                $groupName = $group.Name -replace '_', '.'
                                if ($PSTypeName) {
                                    foreach ($psuedoType in $PSTypeName) {
                                        if ($cmd.pstypenames -notcontains $psuedoType) {
                                            $cmd.pstypenames.insert(0, $psuedoType)        
                                        }
                                    }
                                }
                                if ($cmd.pstypenames -notcontains $groupName) {
                                    $cmd.pstypenames.insert(0, $groupName)
                                }
                            }
                            $cmd
                         
            }   
            )
        }
    }
}

