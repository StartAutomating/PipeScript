
<#
.SYNOPSIS
    Determines if any validation passes, given an object.
.DESCRIPTION
    Determines if any of the `[ValidateScript]` or `[ValidatePattern]` attributes on a `[ScriptBlock]` passes, given an input.

    Any input considered valid by a `[ValidateScript]` or `[ValidatePattern]` will be returned.
.EXAMPLE
    {
        [ValidatePattern("a")]
        [ValidatePattern("b")]
        param()
    }.AnyValidMatch("c","b","a")    
#>
param()

$allArgs = $args | & { process { $_ }}

, @(foreach ($attr in $this.Attributes) {
    if (-not $attr.Validate) { continue }
    if ($attr.Validate -isnot [ValidatePattern]) { continue }
    foreach ($arg in $allArgs) {
        if ($attr.Validate($arg)) {
            $arg
        }
    }    
})