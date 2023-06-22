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


