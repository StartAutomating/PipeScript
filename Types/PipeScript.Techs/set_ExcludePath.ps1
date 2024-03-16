<#
.SYNOPSIS
    Changes the Exclusion Paths
.DESCRIPTION
    Sets any excluded paths for interpreted languages in PipeScript.

    If a command matches any of these patterns, it should not be interpreted.
.NOTES
    Excluded paths will be processed as wildcards.
#>
$paths = @(foreach ($arg in $args | . { process { $_ }}) {
    "$arg"
})

Add-Member -InputObject $this -Force -MemberType NoteProperty -Name '.ExcludePath' -Value $paths
