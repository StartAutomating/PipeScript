<#
.SYNOPSIS
    Sets language exclusions
.DESCRIPTION
    Gets any excluded patterns and paths for languages in PipeScript.
.NOTES
    If you provide a `[regex]`, it will set `.ExcludePattern`.
    Otherwise, this will set `.ExcludePath`.
#>
$unrolledArgs = $args | . { process {  $_ } }
$patterns = @()
$paths = @(
foreach ($arg in $unrolledArgs) {
    if ($arg -is [Regex]) {
        $patterns += $arg
    } else {
        "$arg"
    }
})

if ($patterns) {
    $this.ExcludePattern = $patterns
}
if ($paths) {
    $this.ExcludePath = $paths
}
