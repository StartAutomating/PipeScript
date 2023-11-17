<#
.SYNOPSIS
    Validates an Object against a Pattern
.DESCRIPTION
    Validates one or more objects against the .RegexPattern of this attribute.
.EXAMPLE
    [ValidatePattern]::new("a").Validate("a") # Should -Be $true
.EXAMPLE
    [ValidatePattern]::new("a").Validate("b") # Should -Be $false
#>
param()

$allArguments = @($args | & { process { $_ } })

$ThisPattern = [Regex]::new(
    $this.RegexPattern, 
    $this.Options,
    [timespan]::FromMilliseconds(50)
)


# Validating a Pattern is simple
foreach ($argument in $allArguments) {
    if (-not $ThisPattern.IsMatch("$argument")) {
        return $false
    }
}
return $true

