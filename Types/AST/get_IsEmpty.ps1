<#
.SYNOPSIS
    Determines if a PowerShell AST is empty
.DESCRIPTION
    Determines if a PowerShell Abstract Syntax Tree is empty.

    It will be considered empty if is a ScriptBlockExpression with no parameters or statements in any blocks.
#>
param()
$ast = $this
if ($ast.Body) {
    $ast = $ast.Body
}

if ($ast -isnot [Management.Automation.Language.ScriptBlockExpressionAST]) {
    return $false
}

foreach ($property in $ast.psobject.Properties) {
    if ($property.Name -notmatch 'Block$') { continue }
    if ($property.Value.Statements.Count) { return $false }
    if ($property.Value.Parameters.Count) { return $false }
}

return $true
