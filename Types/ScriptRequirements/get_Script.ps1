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