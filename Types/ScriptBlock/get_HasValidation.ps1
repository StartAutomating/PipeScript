<#
.SYNOPSIS
    Determines if a ScriptBlock has validation
.DESCRIPTION
    Determines if a ScriptBlock has either a `[ValidatePattern]` or a `[ValidateScript]` attribute defined.
.EXAMPLE
    {}.HasValidation
.EXAMPLE
    {[ValidateScript({$true})]param()}.HasValidation
#>
param()
foreach ($attr in $this.Attributes) {
    if ($attr -is [ValidatePattern]) { return $true }
    if ($attr -is [ValidateScript])  { return $true }
}
return $false