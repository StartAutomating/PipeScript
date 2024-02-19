<#
.SYNOPSIS
    Changes the Exclusion Patterns
.DESCRIPTION
    Sets any excluded patterns for interpreted languages in PipeScript.

    If a command matches any of these patterns, it should not be interpreted.
.NOTES
    Under most circumstances, this should not be set.
    
    Setting this may cause Templates and Protocols to stop working (for interpretable languages)
#>
$patterns = @(foreach ($arg in $args | . { process { $_ }}) {
    [Regex]::new("$arg","IgnoreCase,IgnorePatternWhitespace","00:00:00.1")
})

Add-Member -InputObject $this -Force -MemberType NoteProperty -Name '.ExcludePattern' -Value $patterns
