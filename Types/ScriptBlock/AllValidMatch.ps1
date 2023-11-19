
<#
.SYNOPSIS
    Determines if all validation matches, given an object.
.DESCRIPTION
    Determines if all of the `[ValidatePattern]` attributes on a `[ScriptBlock]` pass, given one or more inputs.

    Any input considered valid by all `[ValidatePattern]` will be returned.

    If there is no validation present, no objects will be returned.
.EXAMPLE
    {
        [ValidatePattern("a")]
        [ValidatePattern("c$")]
        param()
    }.AllValidMatches("c","b","a","abc")
.EXAMPLE
    {
        [ValidatePattern("a")]
        [ValidatePattern("c$")]
        param()
    }.AllValidMatch("c","b","a","abc")
#>
param()

$allArgs = $args | & { process { $_ }}

, @(
:nextArg foreach ($arg in $allArgs) {
    $validatedArg = $false
    foreach ($attr in $this.Attributes) {
        if (-not $attr.Validate) { continue }
        if ($attr -isnot [ValidatePattern]) { continue }
        if (-not $attr.Validate($arg)) { continue nextArg}
        else { $validatedArg = $true}
    }
    if ($validatedArg) {
        $arg
    }    
}    
)