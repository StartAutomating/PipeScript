
<#
.SYNOPSIS
    Determines if any validation passes, given an object.
.DESCRIPTION
    Determines if all of the `[ValidateScript]` or `[ValidatePattern]` attributes on a `[ScriptBlock]` pass, given one or more inputs.

    Any input considered valid by all `[ValidateScript]` or `[ValidatePattern]` will be returned.

    If there is no validation present, all objects will be returned.
.EXAMPLE
    {
        [ValidatePattern("a")]
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
    foreach ($attr in $this.Attributes) {
        if (-not $attr.Validate) { continue }
        if (-not $attr.Validate($arg)) { continue nextArg}
    }
    $arg
}    
)