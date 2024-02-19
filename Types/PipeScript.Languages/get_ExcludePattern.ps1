<#
.SYNOPSIS
    Gets Language Exclusion Patterns
.DESCRIPTION
    `$psLanguages.ExcludePattern` and `$psInterpreters.ExcludePattern` contain the patterns excluded from interpretation.

    If a command matches any of these patterns, it should not be interpreted.    
#>
param()

if (-not $this.'.ExcludePattern') {
    Add-Member -InputObject $this -Force -MemberType NoteProperty -Name '.ExcludePattern' @(
        [Regex]::new('\.ps1?\.','IgnoreCase')
        [Regex]::new('://.')
    )
}

return $this.'.ExcludePattern'