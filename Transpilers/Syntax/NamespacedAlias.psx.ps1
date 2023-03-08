<#
.SYNOPSIS
    Declares a namespaced alias
.DESCRIPTION
    Declares an alias in a namespace.

    Namespaces are used to logically group functionality in a way that can be efficiently queried.
.EXAMPLE
    . {
        PipeScript.Template alias .\Transpilers\Templates\*.psx.ps1
    }.Transpile()
#>
[Reflection.AssemblyMetaData('Order', -10)]
[ValidateScript({
    # This only applies to a command AST
    $cmdAst = $_ -as [Management.Automation.Language.CommandAst]
    if (-not $cmdAst) { return $false }
    # It must have at least 3 elements.
    if ($cmdAst.CommandElements.Count -lt 3) {
        return $false
    }
    # The second element must be 'alias'.
    if ($cmdAst.CommandElements[1].Value -ne 'alias') {
        return $false
    }    
    return $true
})]
param(
# The CommandAST that will be transformed.
[Parameter(Mandatory,ValueFromPipeline)]
[Management.Automation.Language.CommandAst]
$CommandAst
)

process {
    $namespace, $null, $locations = $CommandAst.CommandElements

    $namespaceSeparatorPattern = [Regex]::new('[\p{P}]{1,}','RightToLeft')

    $namespaceSeparator = $namespaceSeparatorPattern.Match($namespace).Value
    if (-not $namespaceSeparator) {
        $namespaceSeparator = '.'
    }

    $namespace = $namespace -replace "$namespaceSeparatorPattern$"

    $locationsEmbed = "'" + $($locations -replace "'","''" -join "','") + "'"

    [ScriptBlock]::Create("
`$aliasNamespace = '$($namespace -replace "'","''")'
`$aliasNamespaceSeparator = '$namespaceSeparator'
foreach (`$aliasNamespacePattern in $locationsEmbed) {
" + {
    $commandsToAlias = $ExecutionContext.SessionState.InvokeCommand.GetCommands($aliasNamespacePattern, 'All', $true)
    if ($commandsToAlias) {
        foreach ($commandToAlias in $commandsToAlias) {
            $aliasName = $aliasNamespace, $commandToAlias.Name -join $aliasNamespaceSeparator
            Set-Alias $aliasName $commandToAlias
            $ExecutionContext.SessionState.PSVariable.Set($aliasName, 
                $ExecutionContext.SessionState.InvokeCommand.GetCommand($aliasName, 'Alias')
            )
        }
    }

    if (Test-Path $aliasNamespacePattern) {
        foreach ($fileToAlias in (Get-ChildItem -Path $aliasNamespacePattern)) {
            $aliasName = $aliasNamespace, $fileToAlias.Name -join $aliasNamespaceSeparator
            Set-Alias $aliasName $fileToAlias.FullName
            $ExecutionContext.SessionState.PSVariable.Set($aliasName, 
                $ExecutionContext.SessionState.InvokeCommand.GetCommand($aliasName, 'Alias')
            )
        }
    }    
} + "
}
")
    

    
}

