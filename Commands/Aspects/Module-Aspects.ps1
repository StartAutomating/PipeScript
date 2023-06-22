
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
            
        foreach ($commandType in @($ModuleCommandTypes.GetEnumerator() | Sort-Object Key)) {
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
            
        # With some clever understanding of Regular expressions, we can make match any/all of our potential command types.
        # Essentially: Regular Expressions can look ahead (matching without changing the position), and be optional.
        # So we can say "any/all" by making a series of optional lookaheads.
        
        # We'll go thru each pattern in order
        $combinedRegex = @(foreach ($categoryKeyValue in $ModuleCommandTypes.GetEnumerator() | Sort-Object Key) {
            $categoryPattern = 
                if ($categoryKeyValue.Value -is [string]) {
                    $categoryKeyValue.Value
                } else {
                    $categoryKeyValue.Value.Pattern
                }
            # ( and skip anyone that does not have a pattern)
            if (-not $categoryPattern) { continue } 
            '(?=' + # Start a lookahead
                '.{0,}' + # match any or no characters
                # followed by the command pattern
                "(?<$Prefix$($categoryKeyValue.Key -replace '\p{P}', '_')$Suffix>$categoryPattern)" +
                ')?' # made optional                            
        }) -join [Environment]::NewLine
        # Now that we've combined the whole thing, make it a Regex and output it.        
        [Regex]::new("$combinedRegex", 'IgnoreCase,IgnorePatternWhitespace','00:00:01')
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
                                      
                                  # With some clever understanding of Regular expressions, we can make match any/all of our potential command types.
                                  # Essentially: Regular Expressions can look ahead (matching without changing the position), and be optional.
                                  # So we can say "any/all" by making a series of optional lookaheads.
                                  
                                  # We'll go thru each pattern in order
                                  $combinedRegex = @(foreach ($categoryKeyValue in $ModuleCommandTypes.GetEnumerator() | Sort-Object Key) {
                                      $categoryPattern = 
                                          if ($categoryKeyValue.Value -is [string]) {
                                              $categoryKeyValue.Value
                                          } else {
                                              $categoryKeyValue.Value.Pattern
                                          }
                                      # ( and skip anyone that does not have a pattern)
                                      if (-not $categoryPattern) { continue } 
                                      '(?=' + # Start a lookahead
                                          '.{0,}' + # match any or no characters
                                          # followed by the command pattern
                                          "(?<$Prefix$($categoryKeyValue.Key -replace '\p{P}', '_')$Suffix>$categoryPattern)" +
                                          ')?' # made optional                            
                                  }) -join [Environment]::NewLine
                                  # Now that we've combined the whole thing, make it a Regex and output it.        
                                  [Regex]::new("$combinedRegex", 'IgnoreCase,IgnorePatternWhitespace','00:00:01')
                              }
                           } $ModuleInfo -Prefix $prefix -Suffix $Suffix
        if ($PSBoundParameters['FilePath']) {
            $(
                    # Collect all items into an input collection
                    $inputCollection = @(($FilePath |& {
                    param([switch]$IncludeApplications)
                    process {
                    $inObj = $_
                    # Since we're looking for commands, pass them thru directly
                    if ($inObj -is [Management.Automation.CommandInfo]) {
                        $inObj
                    }
                    # If the input object is ps1 fileinfo 
                    elseif ($inObj -is [IO.FileInfo] -and $inObj.Extension -eq '.ps1') {
                        # get that exact command.
                        $ExecutionContext.SessionState.InvokeCommand.GetCommand($inObj.Fullname, 'ExternalScript')
                    }
                    # If the input is a string or path        
                    elseif ($pathItem -is [IO.FileInfo] -and $IncludeApplications) {
                        $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'Application')
                    }
                    elseif ($inObj -is [string] -or $inObj -is [Management.Automation.PathInfo]) {
                        # resolve it
                        foreach ($resolvedPath in $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath("$inObj")) {
                            # and get the literal item
                            $pathItem = Get-item -LiteralPath $resolvedPath
                            # if it is a .ps1 fileinfo
                            if ($pathItem -is [IO.FileInfo] -and $pathItem.Extension -eq '.ps1') {
                                # get that exact command
                                $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'ExternalScript')
                            } 
                            elseif ($pathItem -is [IO.FileInfo] -and $IncludeApplications) {
                                $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'Application')
                            }
                            elseif ($pathItem -is [IO.DirectoryInfo]) {
                                # Otherwise, get all files beneath the path
                                foreach ($pathItem in @(Get-ChildItem -LiteralPath $pathItem -File -Recurse)) {
                                    # that are .ps1
                                    if ($pathItem.Extension -eq '.ps1') {
                                        # and return them directly.
                                        $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'ExternalScript')
                                    }
                                    elseif ($IncludeApplications) {
                                        $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'Application')
                                    }
                                }
                            }
                        }
                    }
                } }))
            # Walk over each item in the filtered collection
            foreach ($item in $inputCollection) {
                # we set $this, $psItem, and $_ for ease-of-use.
                $this = $_ = $psItem = $item
                
                            $cmd = $_                
                            $matched = $CommandPattern.Match("$cmd")
                            if (-not $matched.Success) { continue }
                            $NamedGroupMatch = $false
                            foreach ($group in $matched.Groups) {
                                if (-not $group.Success) { continue }
                                if ($null -ne ($group.Name -as [int])) { continue }
                                $NamedGroupMatch = $true
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
                            if ($NamedGroupMatch) {
                                $cmd
                            } 
                         
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
                            $NamedGroupMatch = $false
                            foreach ($group in $matched.Groups) {
                                if (-not $group.Success) { continue }
                                if ($null -ne ($group.Name -as [int])) { continue }
                                $NamedGroupMatch = $true
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
                            if ($NamedGroupMatch) {
                                $cmd
                            }
                            
                         
            }   
            )
        }
    }
}

