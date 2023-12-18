<#
.SYNOPSIS
    Determines if a ScriptBlock AST is empty
.DESCRIPTION
    Determines if a ScriptBlock AST is empty.

    A ScriptBlock is considered empty if it's Abstract Syntax Tree contains no statements or parameters.
#>
$ast = $this
if ($ast.Body) {
    $ast = $ast.Body
}
foreach ($property in $ast.psobject.Properties) {
    if ($property.Name -notmatch 'Block$') { continue }
    if ($property.Value.Statements.Count) { return $false }
    if ($property.Value.Parameters.Count) { return $false }
}

return $true
