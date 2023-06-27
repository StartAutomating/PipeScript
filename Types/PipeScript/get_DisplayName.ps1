<#
.SYNOPSIS
    Gets display names.
.DESCRIPTION
    Gets the display name of a PipeScript command.
#>
if (-not $this.'.DisplayName') {
    if (-not $script:PipeScriptModuleCommandPattern) {
        $script:PipeScriptModuleCommandPattern = # Aspect.ModuleCommandPattern
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
                                                                                         
                                                                                         [PSCustomObject]$SortedExtensionTypes
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
                                                  } -Module PipeScript   
    }
    if ($script:PipeScriptModuleCommandPattern) {
        $displayName = $this.Name -replace $script:PipeScriptModuleCommandPattern
        if (-not $displayName) {
            $displayName = $this.Name
        }
        Add-Member NoteProperty '.DisplayName' -InputObject $this -Value $displayName -Force
    }
}
$this.'.DisplayName'


