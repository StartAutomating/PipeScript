<#
.SYNOPSIS
    Determines if a given route is valid
.DESCRIPTION
    Determines if a given route is valid and could be used.
.EXAMPLE

#>
param()

$unrolledArgs = $args | . { process { $_ }}

$psRoute = $this
$routeScriptBlock = 
if ((-not $psRoute.ScriptBlock) -and $psRoute.ResolvedCommand.ScriptBlock) {
    $psRoute.ResolvedCommand.ScriptBlock
} elseif ($psRoute.ScriptBlock) {
    $psRoute.ScriptBlock
}

if (-not $routeScriptBlock) { return $false }

$validationAttributes = foreach ($attr in $routeScriptBlock.Attributes) {
    if (-not $attr.Validate) { continue }
    if ($attr.ErrorMessage -notmatch '^\$request') {
        Write-Verbose "Skipping Validation for routing because '$($attr.ErrorMessage)' does not start with '`$Request'"
        continue        
    }
    $attr
}

if (-not $validationAttributes) { return $false }

foreach ($validationAttribute in $validationAttributes) {
    if (-not $validationAttribute.Validate($unrolledArgs)) {
        return $false
    }   
}

return $true