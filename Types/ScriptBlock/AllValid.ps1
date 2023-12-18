
<#
.SYNOPSIS
    Determines if any validation passes, given an object.
.DESCRIPTION
    Determines if all of the `[ValidateScript]` or `[ValidatePattern]` attributes on a `[ScriptBlock]` pass, given one or more inputs.

    Any input considered valid by all `[ValidateScript]` or `[ValidatePattern]` will be returned.

    If there is no validation present, no objects will be returned.
.EXAMPLE
    {
        [ValidatePattern("a")]
        [ValidatePattern("c$")]
        param()
    }.AllValid("c","b","a","abc")
.EXAMPLE
    {
        [ValidateScript({$_ % 2})]
        [ValidateScript({-not ($_ % 3)})]
        param()
    }.AllValid(1..10)    
#>
param()

$allArgs = $args | & { process { $_ }}

, @(
:nextArg foreach ($arg in $allArgs) {
    $validatedArg = $false
    foreach ($attr in $this.Attributes) {
        if (-not $attr.Validate) { continue }
        if (-not $attr.Validate($arg)) { continue nextArg}
        else { $validatedArg = $true }
    }
    if ($validatedArg) {
        $arg
    }    
}    
)