<#
.SYNOPSIS
    Object Keyword
.DESCRIPTION
    The Object Keyword helps you create objects or get the .NET type, `object`.
.EXAMPLE
    Use-PipeScript { object { $x = 1; $y = 2 }} 
.EXAMPLE
    Use-PipeScript { object @{ x = 1; y = 2 }}
.EXAMPLE
    Use-PipeScript { Object }
#>
[ValidateScript({
    $validating = $_

    # This is only valid for commands
    if ($validating -isnot [Management.Automation.Language.CommandAst]) { return $false }
    
    # that have exactly two command elements.
    if ($validating.CommandElements.Count -gt 2) { return $false }

    # The first element must be "Object"
    if ($validating.CommandElements[0].Value -ne 'Object') { return $false }

    return $true
})]
[Reflection.AssemblyMetadata("PipeScript.Keyword",$true)]
param(
# The Command Ast for the Object Keyword
[Parameter(ValueFromPipeline)]
[Management.Automation.Language.CommandAst]
$ObjectCommandAst
)

process {
    # If we're not "object", return.
    if ($ObjectCommandAst.CommandElements[0].Value -ne 'Object') { return }
    # If we have less than two command elements, return.
    if ($ObjectCommandAst.CommandElements.Count -gt 2) { return }
    # If we have only one command element
    if ($ObjectCommandAst.CommandElements.Count -eq 1) {
        # Create a script that returns [Object]
        return ([scriptblock]::create("[Object]"))
    }

    $ExportAll = "Export-ModuleMember -Variable * -Function * -Alias *"
    switch ($ObjectCommandAst.CommandElements[1]) {
        { $_ -is [Management.Automation.Language.ScriptBlockExpressionAst]} {
            # If it is an expression, we call `New-Module -AsCustomObject` (and export all the members)
            [ScriptBlock]::Create("New-Module -AsCustomObject {$($_ -replace '^\{' -replace '\}$'); $ExportAll}")
        }
        { $_ -is [Management.Automation.Language.HashtableAst]} {
            # If it is an hashtable ast, we cast to `[Ordered]`, then `[PSCustomObject]`.
            [ScriptBlock]::Create("[PSCustomObject][Ordered]$_")
        }
        { $_ -is [Management.Automation.Language.VariableExpressionAst]} {
            # If it is a variable, we try to make it an object.
            [ScriptBlock]::Create(@"
`$(
    if ($_ -is [Collections.IDictionary]) { [PSCustomObject][Ordered]@{} + $_ }
    elseif ($_ -is [ScriptBlock]) { New-Module -AsCustomObject ([ScriptBlock]::Create(`"$_ ; $ExportAll`")) }
    else { $_ }
)
"@)
        }
    }
}
