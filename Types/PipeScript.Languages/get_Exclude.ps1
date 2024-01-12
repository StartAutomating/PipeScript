<#
.SYNOPSIS
    Gets Languages Exclusions
.DESCRIPTION
    Gets any excluded patterns and paths for languages in PipeScript.

    If a command matches any of these patterns, it should not be interpreted.
#>
param()


return @(
    $this.ExcludePattern
    $this.ExcludePath
)