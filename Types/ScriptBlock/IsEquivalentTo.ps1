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

$this.Ast.IsEquivalentTo($other)