
<#
.SYNOPSIS
    Determines if any validation passes, given an object.
.DESCRIPTION
    Determines if any of the `[ValidateScript]` attributes on a `[ScriptBlock]` passes, given an input.

    Any input considered valid by a `[ValidateScript]` will be returned.
.EXAMPLE
    {
        [ValidateScript({$_ -like "a*" })]        
        param()
    }.AnyValidObject("a")    
#>
param()

$allArgs = $args | & { process { $_ }}

, @(foreach ($attr in $this.Attributes) {
    if (-not $attr.Validate) { continue }
    if ($attr.Validate -isnot [ValidateScript]) { continue }
    foreach ($arg in $allArgs) {
        if ($attr.Validate($arg)) {
            $arg
        }
    }    
})