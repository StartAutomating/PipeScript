Aspect function ModuleCommandType {
    <#
    .SYNOPSIS
        Returns a module's command types
    .DESCRIPTION
        Returns the command types defined in a module's manifest.        
    #>
    [Alias('Aspect.ModuleCommandTypes')]
    param(
    # The name of a module, or a module info object.
    [vbn(Mandatory)]
    [ValidateTypes(TypeName={[string],[Management.Automation.PSModuleInfo]})]
    $Module
    )

    process {
        if ($Module -is [string]) {
            $Module = Get-Module $Module
        }
        $ModuleInfo = $module
        

        #region Search for Module Command Types
        return if -not $ModuleInfo
        $ModuleCommandTypes = 
            @($ModuleInfo.PrivateData.CommandType,
            $ModuleInfo.PrivateData.CommandTypes,
            $ModuleInfo.PrivateData.PSData.CommandType,
            $ModuleInfo.PrivateData.PSData.CommandType -ne $null)[0]

        
        return if -not $ModuleCommandTypes
            
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

Aspect function ModuleCommandPattern {
    <#
    .SYNOPSIS
        Returns a module's command pattern
    .DESCRIPTION
        Returns a regular expression that can match 
    #>
    param(
    # The name of a module, or a module info object.
    [vbn(Mandatory)]
    [ValidateTypes(TypeName={[string],[Management.Automation.PSModuleInfo]})]
    $Module,

    # The suffix to apply to each named capture.
    # Defaults to '_Command'
    [vbn()]
    [string]
    $Suffix = '_Command',

    # The prefix to apply to each named capture. 
    [vbn()]
    [string]
    $Prefix
    )

    process {
        if ($Module -is [string]) {
            $Module = Get-Module $Module
        }
        $ModuleInfo = $module


        #region Search for Module Command Types
        return if -not $ModuleInfo
        $ModuleCommandTypes = 
            @($ModuleInfo.PrivateData.CommandType,
            $ModuleInfo.PrivateData.CommandTypes,
            $ModuleInfo.PrivateData.PSData.CommandType,
            $ModuleInfo.PrivateData.PSData.CommandType -ne $null)[0]

        
        return if -not $ModuleCommandTypes
            
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
        [Regex]::new("($combinedRegex)", 'IgnoreCase,IgnorePatternWhitespace')
    }
}

Aspect function ModuleExtendedCommand {
    <#
    .SYNOPSIS
        Returns a module's extended commands
    .DESCRIPTION
        Returns the commands or scripts in a module that match the module command pattern.

        Each returned script will be decorated with the typename(s) that match,
        so that the extended commands can be augmented by the extended types system.

    .LINK
        Aspect.ModuleCommandPattern
    #>
    [Alias('Aspect.ModuleExtensionCommand')]
    param(
    # The name of a module, or a module info object.
    [vbn(Mandatory)]
    [ValidateTypes(TypeName={[string],[Management.Automation.PSModuleInfo]})]
    $Module,

    # The suffix to apply to each named capture.
    # Defaults to '_Command'
    [vbn()]
    [string]
    $Suffix = '_Command',

    # The prefix to apply to each named capture. 
    [vbn()]
    [string]
    $Prefix,
        
    [vbn()]
    [Alias('Fullname')]    
    $FilePath
    )

    process {        
        if ($Module -is [string]) {
            $Module = Get-Module $Module
        }
        $ModuleInfo = $module

        return if -not $ModuleInfo
        
        $CommandPattern = ModuleCommandPattern $ModuleInfo -Prefix $prefix -Suffix $Suffix

        
        
        if ($FilePath) {
            all scripts in $FilePath matching $CommandPattern foreach {
                $cmd = $_
                $n = $cmd.Name
                $matched = $CommandPattern.Match($n)
                if (-not $matched.Success) { return }
                foreach ($group in $matched.Groups) {
                    if (-not $group.Success) { continue }
                    if ($null -ne ($group.Name -as [int])) { continue }
                    $groupName = $group.Name -replace '_', '.'
                    if ($cmd.pstypenames -notcontains $groupName) {
                        $cmd.pstypenames.insert(0, $groupName)
                    }                    
                }
                $cmd    
            }
        }
        else {
            all functions cmdlets aliases matching $CommandPattern foreach {
                $cmd = $_
                $n = $cmd.Name
                $matched = $CommandPattern.Match($n)
                if (-not $matched.Success) { return }
                foreach ($group in $matched.Groups) {
                    if (-not $group.Success) { continue }
                    if ($null -ne ($group.Name -as [int])) { continue }
                    $groupName = $group.Name -replace '_', '.'
                    if ($cmd.pstypenames -notcontains $groupName) {
                        $cmd.pstypenames.insert(0, $groupName)
                    }                    
                }
                $cmd
            }
        }


    }
}