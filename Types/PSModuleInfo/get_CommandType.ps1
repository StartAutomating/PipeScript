<#
.SYNOPSIS
    Gets Module Command Types
.DESCRIPTION
    Gets Command Types defined within a Module
.EXAMPLE
    (Get-Module PipeScript).CommandType
#>
param()

if (-not $this.'.CommandTypes') {
    Add-Member -InputObject $this -MemberType NoteProperty -Force -Name '.CommandTypes' (
        # Aspect.ModuleCommandType
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
        
        
         } -Module $this
    )        
}
$this.'.CommandTypes'

