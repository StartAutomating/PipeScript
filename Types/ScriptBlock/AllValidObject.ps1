
<#
.SYNOPSIS
    Determines if all validation matches, given an object.
.DESCRIPTION
    Determines if all of the `[ValidateScript]` attributes on a `[ScriptBlock]` pass, given one or more inputs.

    Any input considered valid by all `[ValidateScript]` will be returned.

    If there is no validation present, no objects will be returned.
.EXAMPLE
    {
        [ValidateScript({$_ % 2})]
        [ValidateScript({-not ($_ % 3)})]
        param()
    }.AllValidObject(1..10)    
.EXAMPLE
#>
param()

$allArgs = $args | & { process { $_ }}

, @(
:nextArg foreach ($arg in $allArgs) {
    $validatedArg = $false
    foreach ($attr in $this.Attributes) {
        if (-not $attr.Validate) { continue }
        if ($attr -isnot [ValidateScript]) { continue }
        if (-not $attr.Validate($arg)) { continue nextArg}
        else { $validatedArg = $true}
    }
    if ($validatedArg) {
        $arg
    }    
}    
)