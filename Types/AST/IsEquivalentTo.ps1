<#
.SYNOPSIS
    Attempts to Determine Ast Equivalence
.DESCRIPTION
    Attempts to Determine if `$this` Ast element is the same as some `$Other` object.

    If `$Other is a `[string]`, it will be converted into a `[ScriptBlock]`
    If `$Other is a `[ScriptBlock]`, it will become the `[ScriptBlock]`s AST

    If the types differ, `$other is not equivalent to `$this.

    If the content is the same with all whitespace removed, it will be considered equivalent.
.NOTES
    Due to the detection mechanism, IsEquivalentTo will consider strings with whitespace changes equivalent.
#>
param(
# The other item.
$Other
)

if (-not $other) { return $false }

if ($other -is [string]) {
    $other = [ScriptBlock]::Create($other).Ast
}

if ($other -is [scriptblock]) {
    $other = $Other.Ast
}

if ($other -isnot [Management.Automation.Language.Ast]) {
    return $false
}

if ($other.GetType() -ne $this.GetType()) { return $false }

# We're going to start off very easy, and slightly incorrect:
($this -replace '[\s\r\n]') -eq ($other -replace '[\s\r\n]')

# (There are many cases where, say, variable renames would be innocuous, but that's a rabbit hole of variable detection.  The same is true of commands.)

# However, in 98% of cases, two scriptblocks without whitespace that are the same are equivalent.  The exception to the rule: whitespace within strings.