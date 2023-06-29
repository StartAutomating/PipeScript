<#
.SYNOPSIS
    Gets the script that represents a requires statement
.DESCRIPTION
    Gets the a PowerShell `[ScriptBlock]` that #requires the exact same list of script requirements.

    This script method exists because it provides a way to check the requirements without actually running a full script.
.EXAMPLE
    [ScriptBlock]::Create('#requires -Module PipeScript').Ast.ScriptRequirements.Script
#>
$requirement = $this
[ScriptBlock]::create(
    @(if ($requirement.RequirementPSVersion) {
        "#requires -Version $($requirement.RequirementPSVersion)"
    }
    if ($requirement.IsElevationRequired) {
        "#requires -RunAsAdministrator"
    }
    if ($requirement.RequiredModules) {
        "#requires -Module $(@(foreach ($reqModule in $requirement.RequiredModules) {
            if ($reqModule.Version -or $req.RequiredVersion -or $req.MaximumVersion) {
                '@{' + $(@(foreach ($prop in $reqModule.PSObject.Properties) {
                    if (-not $prop.Value) { continue }
                    if ($prop.Name -in 'Name', 'Version') {
                        "Module$($prop.Name)='$($prop.Value.ToString().Replace("'","''"))'"
                    } elseif ($prop.Name -eq 'RequiredVersion') {
                        "MinimumVersion='$($prop.Value)'" 
                    } else {
                        "$($prop.Name)='$($prop.Value)'" 
                    }
                }) -join ';') + '}'
            } else {
                $reqModule.Name
            }
        }) -join ',')"
    }
    if ($requirement.RequiredAssemblies) {
        "#requires -Assembly $($requirement.RequiredAssemblies -join ',')"
    }) -join [Environment]::NewLine
)