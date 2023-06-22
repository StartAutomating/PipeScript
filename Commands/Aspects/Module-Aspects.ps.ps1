Aspect function ModuleCommandType {
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

Aspect function ModuleCommandPattern {
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
            continue if -not $categoryPattern

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
    .EXAMPLE
        Aspect.ModuleExtendedCommand -Module PipeScript # Should -BeOfType ([Management.Automation.CommandInfo])
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

    # The file path(s).  If provided, will look for commands within these paths.
    [vbn()]
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

        return if -not $ModuleInfo
        
        $CommandPattern = ModuleCommandPattern $ModuleInfo -Prefix $prefix -Suffix $Suffix

        if ($PSBoundParameters['FilePath']) {
            all scripts in $FilePath foreach {
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
        }
        else {
            all functions cmdlets aliases foreach {
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
        }
    }
}