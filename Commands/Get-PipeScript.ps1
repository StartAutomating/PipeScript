function Get-PipeScript {
    <#
    .SYNOPSIS
        Gets PipeScript.
    .DESCRIPTION        
        Gets PipeScript and it's extended commands.
        Because 'Get' is the default verb in PowerShell,
        Get-PipeScript also allows you to run other commands in noun-oriented syntax.
    .EXAMPLE
        Get-PipeScript
    .EXAMPLE
        Get-PipeScript -PipeScriptType Transpiler
    .EXAMPLE
        Get-PipeScript -PipeScriptType Template -PipeScriptPath $pwd
    .EXAMPLE
        PipeScript Invoke { "hello world" } # Should -Be 'Hello World'
    .EXAMPLE
        { partial function f { } }  |
            PipeScript Import -PassThru # Should -BeOfType ([Management.Automation.PSModuleInfo])
    #>
    [CmdletBinding(PositionalBinding=$false)]
    param(
    # The path containing pipescript files.
    # If this parameter is provided, only PipeScripts in this path will be outputted.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Fullname','FilePath','Source')]
    [string]
    $PipeScriptPath,
    # One or more PipeScript Command Types.    
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateSet('Analyzers','Aspect','AutomaticVariable','BuildScript','Interface','Optimizer','Partial','PipeScriptNoun','PostProcessor','PreProcessor','Protocol','Sentence','Template','Transpiler')]
    [string[]]
    $PipeScriptType,
    # Any positional arguments that are not directly bound.
    # This parameter primarily exists to allow Get-PipeScript to pass it down to other commands.
    [Parameter(ValueFromRemainingArguments)]
    [Alias('Args')]
    $Argument,
    # The InputObject.
    # This parameter primarily exists to allow Get-PipeScript to pass it down to other commands.
    [Parameter(ValueFromPipeline)]
    [Alias('Input','In')]    
    $InputObject,
    # If set, will force a refresh of the loaded Pipescripts.
    [switch]
    $Force
    )
    dynamicParam {
             
       
$myCommandAst=$($MyCaller=$($myCallStack=@(Get-PSCallstack)
             $myCallStack[-1])
         if ($MyCaller) {
                $myInv = $MyInvocation
                $MyCaller.InvocationInfo.MyCommand.ScriptBlock.Ast.FindAll({
                    param($ast) 
                        $ast.Extent.StartLineNumber -eq $myInv.ScriptLineNumber -and
                        $ast.Extent.StartColumnNumber -eq $myInv.OffsetInLine -and 
                        $ast -is [Management.Automation.Language.CommandAst]
                },$true)
            })
 $myModule = Get-Module PipeScript
        $myInv    = $MyInvocation
        
        # Fun PowerShell fact:  'Get' is the default verb.
        # So when someone uses a noun-centric form of PipeScript, this command will be called.
        if ($MyInvocation.InvocationName -eq 'PipeScript') {
            # In this way, we can 'trick' the command a bit.
            $myCmdAst  = $myCommandAst
            
            if (-not ($myCmdAst -or $MyInvocation.Line -match '(?<w1>PipeScript)\s(?<w2>\S+)')) { return }
                
            $FirstWord, $secondWord, $restOfLine = 
                if ($myCmdAst.CommandElements) {
                    $myCmdAst.CommandElements
                } elseif ($matches) {
                    $matches.w1, $matches.w2
                }
                            
            # If the second word is a verb and the first is a noun
            if ($myModule.ExportedCommands["$SecondWord-$FirstWord"] -and # and we export the command
                $myModule.ExportedCommands["$SecondWord-$FirstWord"] -ne $myInv.MyCommand # (and it's not this command)
            ) {
                # Then we could do something, like:             
                $myModule.ExportedCommands["$SecondWord-$FirstWord"] |
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
                                Aspect.DynamicParameter -IncludeParameter Name # Select -Expand Keys | Should -Be Name
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
                     } -PositionOffset 1 -ExcludeParameter @($myInv.MyCommand.Parameters.Keys) -BlankParameterName Verb                                
            }                                    
        }
    }
    begin {
        #region Declare Internal Functions and Filters
        function SyncPipeScripts {
                    param($Path,$Force)
                    # If we do not have a commands at path collection, create it.
                   
        $ModuleExtendedCommandAspect = { 
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
                                                                              
                                                                          $combinedRegex = @(foreach ($categoryKeyValue in $ModuleCommandTypes.GetEnumerator() | Sort-Object Key) {
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
                    $CommandPatternAspect = { 
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
                                                                              
                                                                          $combinedRegex = @(foreach ($categoryKeyValue in $ModuleCommandTypes.GetEnumerator() | Sort-Object Key) {
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
         if (-not $script:CachedCommandsAtPath) {
                        $script:CachedCommandsAtPath = @{}
                    }
                    
                    if ($Force) { # If we are using -Force,                                
                        if ($path) { # Then check if a -Path was provided,
                            # and clear that path's cache.
                            $script:CachedCommandsAtPath[$path] = @()
                        } else {
                            # If no -Path was provided,                    
                            $script:CachedPipeScripts = $null # clear the command cache.
                        }                
                    }
                    
                    # If we have not cached all pipescripts.
                    if (-not $script:CachedPipeScripts -and -not $Path) {                
                        $script:CachedPipeScripts = @(
                            # Find the extended commands for PipeScript
                            # Aspect.ModuleExtendedCommand
                            & $ModuleExtendedCommandAspect -Module $myModule -PSTypeName PipeScript
                            # Determine the related modules for PipeScript.
                            $moduleRelationships = 
                                                   @(
                                                   $MyModuleName, $myModule = 
                                                       if ($myModule -is [string]) {
                                                           $myModule, (Get-Module $myModule)
                                                       } elseif ($myModule -is [Management.Automation.PSModuleInfo]) {
                                                           $myModule.Name, $myModule
                                                       } else {
                                                           Write-Error "$myModule must be a [string] or [Management.Automation.PSModuleInfo]"    
                                                       }
                                                   #region Search for Module Relationships
                                                   if ($myModule -and $MyModuleName) {
                                                       foreach ($loadedModule in Get-Module) { # Walk over all modules.
                                                           if ( # If the module has PrivateData keyed to this module
                                                               $loadedModule.PrivateData.$myModuleName
                                                           ) {
                                                               # Determine the root of the module with private data.            
                                                               $relationshipData = $loadedModule.PrivateData.$myModuleName
                                                               [PSCustomObject][Ordered]@{
                                                                   PSTypeName     = 'Module.Relationship'
                                                                   Module        = $myModule
                                                                   RelatedModule = $loadedModule
                                                                   PrivateData   = $loadedModule.PrivateData.$myModuleName
                                                               }
                                                           }
                                                           elseif ($loadedModule.PrivateData.PSData.Tags -contains $myModuleName) {
                                                               [PSCustomObject][Ordered]@{
                                                                   PSTypeName     = 'Module.Relationship'
                                                                   Module        = $myModule
                                                                   RelatedModule = $loadedModule
                                                                   PrivateData   = @{}
                                                               }
                                                           }
                                                       }
                                                   }
                                                   #endregion Search for Module Relationships
                                                   )
                                                   
                            $relatedPaths = @(foreach ($relationship in $moduleRelationships) {
                                $relationship.RelatedModule.Path | Split-Path
                            })
                            
                            # then find all commands within those paths.
                            # Aspect.ModuleExtendedCommand
                            & $ModuleExtendedCommandAspect -Module PipeScript -FilePath $relatedPaths -PSTypeName PipeScript
                        )
                    }
                    if ($path -and -not $script:CachedCommandsAtPath[$path]) {
                        $script:CachedCommandsAtPath[$path] = @(
                            # Aspect.ModuleExtendedCommand
                            & $ModuleExtendedCommandAspect -Module PipeScript -FilePath $path -PSTypeName PipeScript
                        )
                    }
                
        }
        filter CheckPipeScriptType {
                    if ($PipeScriptType) {
                        $OneOfTheseTypes = "(?>$($PipeScriptType -join '|'))"
                        $in = $_
                        if (-not ($in.pstypenames -match $OneOfTheseTypes)) {
                            return
                        }
                    }
                    $_
                
        }
        filter unroll {
         $_ 
        }   
        #endregion Declare Internal Functions and Filters
        
        $steppablePipeline = $null
        if ($MyInvocation.InvocationName -eq 'PipeScript') {
            $mySplat = [Ordered]@{} + $PSBoundParameters
            $myCmdAst  = $myCommandAst
            if ($myCmdAst -or $MyInvocation.Line -match '(?<w1>PipeScript)\s(?<w2>\S+)') {
                
                $FirstWord, $secondWord, $restOfLine = 
                    if ($myCmdAst.CommandElements) {
                        $myCmdAst.CommandElements
                    } elseif ($matches) {
                        $matches.w1, $matches.w2
                    }
                
                # If the second word is a verb and the first is a noun
                if ($myModule.ExportedCommands["$SecondWord-$FirstWord"] -and # and we export the command
                    $myModule.ExportedCommands["$SecondWord-$FirstWord"] -ne $myInv.MyCommand # (and it's not this command)
                ) {
                    # Remove the -Verb parameter,
                    $mySplat.Remove('Verb')
                    # get the export,
                    $myExport = $myModule.ExportedCommands["$SecondWord-$FirstWord"]
                    # turn positional arguments into an array,
                    $myArgs = @(
                        if ($mySplat.Argument) {
                            $mySplat.Argument
                            $mySplat.Remove('Argument')
                        }
                    )
                    
                    # create a steppable pipeline command,
                    $steppablePipelineCmd = {& $myExport @mySplat @myArgs}
                    # get a steppable pipeline,
                    $steppablePipeline = $steppablePipelineCmd.GetSteppablePipeline($MyInvocation.CommandOrigin)
                    # and start the steppable pipeline.
                    $steppablePipeline.Begin($PSCmdlet)
                }                
            }            
        }
        
        # If there was no steppable pipeline
        if (-not $steppablePipeline -and 
            $Argument -and # and we had arguments
            $(
                $argPattern = "(?>$($argument -join '|'))" -as [Regex]
                $validArgs = $myInv.MyCommand.Parameters['PipeScriptType'].Attributes.ValidValues -match $argPattern # that could be types                
                $validArgs
            )
        ) {
            # imply the -PipeScriptType parameter positionally.
            $PipeScriptType = $validArgs
        }
    }
    process {
        $myInv = $MyInvocation
        if ($steppablePipeline) {
            $steppablePipeline.Process($_)
            return
        }
        # If the invocation name is PipeScript (but we have no steppable pipeline or spaced in the name)
        if ($myInv.InvocationName -eq 'PipeScript' -and $myInv.Line -notmatch 'PipeScript\s[\S]+') {
            # return the module
            return $myModule
        }
        
        if ($inputObject -and $InputObject -is [Management.Automation.CommandInfo]) {
            $commandPattern = # Aspect.ModuleCommandPattern
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
                                          
                                      $combinedRegex = @(foreach ($categoryKeyValue in $ModuleCommandTypes.GetEnumerator() | Sort-Object Key) {
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
                               } -Module PipeScript
            $matched = $CommandPattern.Match($InputObject)
            if ($matched.Success) {
                foreach ($group in $matched.Groups) {
                    if (-not $group.Success) { continue }
                    if ($null -ne ($group.Name -as [int])) { continue }
                    $groupName = $group.Name -replace '_', '.'
                    if ($InputObject.pstypenames -notcontains $groupName) {
                        $InputObject.pstypenames.insert(0, $groupName)
                    }                    
                }
                $InputObject
            }
        }    
        elseif ($PipeScriptPath) {
            SyncPipeScripts -Force:$Force -Path $PipeScriptPath
            $script:CachedCommandsAtPath[$PipeScriptPath] | unroll | CheckPipeScriptType
        } else {            
            SyncPipeScripts -Force:$Force
            $script:CachedPipeScripts | unroll | CheckPipeScriptType
        }
    }
    end {
        if ($steppablePipeline) {
            $steppablePipeline.End()
        }
    }
}

