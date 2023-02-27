param([Parameter(Mandatory)]$ParameterName, [PSObject]$Value)

if ($this.Parameters.Count -ge 0 -and 
    $this.Parameters[$parameterName].Attributes
) {
    foreach ($attr in $this.Parameters[$parameterName].Attributes) {
        $_ = $value
        if ($attr -is [Management.Automation.ValidateScriptAttribute]) {
            $result = try { . $attr.ScriptBlock } catch { $null }
            if ($result -ne $true) {
                return $false
            }
        }
        elseif ($attr -is [Management.Automation.ValidatePatternAttribute] -and 
                (-not [Regex]::new($attr.RegexPattern, $attr.Options, '00:00:05').IsMatch($value))
            ) {
                return $false
            }
        elseif ($attr -is [Management.Automation.ValidateSetAttribute] -and 
                $attr.ValidValues -notcontains $value) {
                    return $false
                }
        elseif ($attr -is [Management.Automation.ValidateRangeAttribute] -and (
            ($value -gt $attr.MaxRange) -or ($value -lt $attr.MinRange)
        )) {
            return $false
        }
    }
}
return $true