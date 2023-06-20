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


