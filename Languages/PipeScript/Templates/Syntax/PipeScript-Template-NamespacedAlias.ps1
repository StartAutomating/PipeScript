
function Template.PipeScript.NamespacedAlias {

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
        
        # Attempt to resolve the command
        $potentialCmdName = $cmdAst.CommandElements[0]
        # Attempt to resolve the command
        if (-not $global:AllCommands) {
            $global:AllCommands = $executionContext.SessionState.InvokeCommand.GetCommands('*','Alias,Function,Cmdlet', $true)
        }
        $potentialCmdName = "$($cmdAst.CommandElements[0])"
        return -not ($global:AllCommands.Name -eq $potentialCmdName)    
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
        # If there was no punctuation, the namespace separator will be a '.'
        if (-not $namespaceSeparator) {$namespaceSeparator = '.'}
        # If the pattern was empty brackets `[]`, make the separator `[`.
        elseif ($namespaceSeparator -eq '[]') { $namespaceSeparator = '[' }
        # If the pattern was `<>`, make the separator `<`.
        elseif ($namespaceSeparator -eq '<>') { $namespaceSeparator = '<' }

        $namespace = $namespace -replace "$namespaceSeparatorPattern$"    

        $locationsEmbed = '"' + $($locations -replace '"','`"' -join '","') + '"'

        $scriptBlockToCreate = 
    "
`$aliasNamespace = '$($namespace -replace "'","''")'
`$aliasNamespaceSeparator = '$namespaceSeparator'
`$aliasesToCreate = [Ordered]@{}
foreach (`$aliasNamespacePattern in $locationsEmbed) {
" + {
    $commandsToAlias = $ExecutionContext.SessionState.InvokeCommand.GetCommands($aliasNamespacePattern, 'All', $true)
    if ($commandsToAlias) {
        foreach ($commandToAlias in $commandsToAlias) {
            $aliasName = $aliasNamespace, $commandToAlias.Name -join $aliasNamespaceSeparator
            $aliasesToCreate[$aliasName] = $commandsToAlias            
        }
    }
    elseif (Test-Path $aliasNamespacePattern) {
        foreach ($fileToAlias in (Get-ChildItem -Path $aliasNamespacePattern)) {
            $aliasName = $aliasNamespace, $fileToAlias.Name -join $aliasNamespaceSeparator
            $aliasesToCreate[$aliasName] = $fileToAlias.FullName            
        }
    }
    else {
        $aliasNamespace += $aliasNamespaceSeparator + $aliasNamespacePattern + $aliasNamespaceSeparator
    }
} + "
}
" + {
foreach ($toCreateAlias in $aliasesToCreate.GetEnumerator()) {
    $aliasName, $aliasedTo = $toCreateAlias.Key, $toCreateAlias.Value 
    if ($aliasNamespaceSeparator -match '(?>\[|\<)$') {
        if ($matches.0 -eq '[') { $aliasName += ']' }
        elseif ($matches.0 -eq '<') { $aliasName += '>' }
    }
    Set-Alias $aliasName $commandToAlias
}
}

        [ScriptBlock]::Create($scriptBlockToCreate)       
    }

}

