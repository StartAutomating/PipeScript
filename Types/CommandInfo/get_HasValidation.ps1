foreach ($attr in $this.ScriptBlock.Attributes) {
    if ($attr -is [Management.Automation.ValidateScriptAttribute] -or
        $attr -is [Management.Automation.ValidateSetAttribute] -or 
        $attr -is [Management.Automation.ValidatePatternAttribute] -or 
        $attr -is [Management.Automation.ValidateRangeAttribute]) {
        return $true                        
    }
}

return $false