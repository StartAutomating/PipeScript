<#
.SYNOPSIS
    Object Keyword
.DESCRIPTION
    The Object Keyword helps you create objects
.EXAMPLE
    Use-PipeScript { object { $x = 1; $y = 2 }} 
.EXAMPLE
    Use-PipeScript { object @{ x = 1; y = 2 }}
#>
[ValidateScript({
    $validating = $_

    # This is only valid for commands
    if ($validating -isnot [Management.Automation.Language.CommandAst]) { return $false }
    
    # that have exactly two command elements.
    if ($validating.CommandElements.Count -ne 2) { return $false }

    # The first element must be "Object"
    if ($validating.CommandElements[0].Value -ne 'Object') { return $false }

    return $true
})]
[Reflection.AssemblyMetadata("PipeScript.Keyword",$true)]
param(
[Parameter(ValueFromPipeline)]
[Management.Automation.Language.CommandAst]
$ObjectCommandAst
)

process {
    if ($ObjectCommandAst.CommandElements[0].Value -ne 'Object') { return }
    if ($ObjectCommandAst.CommandElements.Count -ne 2) { return }
    switch ($ObjectCommandAst.CommandElements[1]) {
        { $_ -is [Management.Automation.Language.ScriptBlockExpressionAst]} {            
            [ScriptBlock]::Create("New-Module -AsCustomObject $_")
        }
        { $_ -is [Management.Automation.Language.HashtableAst]} {
            [ScriptBlock]::Create("[PSCustomObject][Ordered]$_")
        }
        { $_ -is [Management.Automation.Language.VariableExpressionAst]} {
            [ScriptBlock]::Create("`$(if ($_ -is [Collections.IDictionary]) { [PSCustomObject][Ordered]@{} + $_ } else { $_ })")
        }
        default {

        }
    }
}
