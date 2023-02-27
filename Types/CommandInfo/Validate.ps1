param(
    # input being validated
    [PSObject]$ValidateInput,
    # If set, will require all [Validate] attributes to be valid.
    # If not set, any input will be valid.
    [switch]$AllValid
)

foreach ($attr in $this.ScriptBlock.Attributes) {
    if ($attr -is [Management.Automation.ValidateScriptAttribute]) {
        try {
            $_ = $this = $psItem = $ValidateInput
            $isValidInput = . $attr.ScriptBlock
            if ($isValidInput -and -not $AllValid) { return $true}
            if (-not $isValidInput -and $AllValid) {
                if ($ErrorActionPreference -eq 'ignore') {
                    return $false
                } elseif ($AllValid) {
                    throw "'$ValidateInput' is not a valid value."
                }
            }
        } catch {
            if ($AllValid) {
                if ($ErrorActionPreference -eq 'ignore') {
                    return $false
                } else {
                    throw
                }
            }
        }
    }
    elseif ($attr -is [Management.Automation.ValidateSetAttribute]) {
        if ($ValidateInput -notin $attr.ValidValues) {
            if ($AllValid) {
                if ($ErrorActionPreference -eq 'ignore') {
                    return $false
                } else {
                    throw "'$ValidateInput' is not a valid value.  Valid values are '$(@($attr.ValidValues) -join "','")'"
                }
            }
        } elseif (-not $AllValid) {
            return $true
        }
    }
    elseif ($attr -is [Management.Automation.ValidatePatternAttribute]) {
        $matched = [Regex]::new($attr.RegexPattern, $attr.Options, [Timespan]::FromSeconds(1)).Match("$ValidateInput")
        if (-not $matched.Success) {
            if ($allValid) {
                if ($ErrorActionPreference -eq 'ignore') {
                    return $false
                } else {
                    throw "'$ValidateInput' is not a valid value.  Valid values must match the pattern '$($attr.RegexPattern)'"
                }
            }
        } elseif (-not $AllValid) {
            return $true
        }
    }
    elseif ($attr -is [Management.Automation.ValidateRangeAttribute]) {
        if ($null -ne $attr.MinRange -and $validateInput -lt $attr.MinRange) {
            if ($AllValid) {
                if ($ErrorActionPreference -eq 'ignore') {
                    return $false
                } else {
                    throw "'$ValidateInput' is below the minimum range [ $($attr.MinRange)-$($attr.MaxRange) ]"
                }
            }
        }
        elseif ($null -ne $attr.MaxRange -and $validateInput -gt $attr.MaxRange) {
            if ($AllValid) {
                if ($ErrorActionPreference -eq 'ignore') {
                    return $false
                } else {
                    throw "'$ValidateInput' is above the maximum range [ $($attr.MinRange)-$($attr.MaxRange) ]"
                }
            }
        }
        elseif (-not $AllValid) {
            return $true
        }
    }
}

if ($AllValid) {
    return $true
} else {
    return $false
}