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

    switch ($ObjectCommandAst.CommandElements[1]) {
        { $_ -is [Management.Automation.Language.ScriptBlockExpressionAst]} {            
            [ScriptBlock]::Create("New-Module -AsCustomObject $_")
        }
        { $_ -is [Management.Automation.Language.HashtableAst]} {
            [ScriptBlock]::Create("[PSCustomObject][Ordered]$_")
        }
        { $_ -is [Management.Automation.Language.VariableExpressionAst]} {
            [ScriptBlock]::Create("`$(if ($_ -is [Collections.IDictionary]) { [PSCustomObject][Ordered]@{} + $_ } elseif ($_ -is [ScriptBlock]) { New-Module -AsCustomObject $_ } else { $_ })")
        }        
    }
}
