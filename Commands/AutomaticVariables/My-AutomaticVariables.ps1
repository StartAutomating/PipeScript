# Declares various 'my' automatic variables

$aliasNamespace = 'Automatic.Variable'
$aliasNamespaceSeparator = '.'
$aliasesToCreate = [Ordered]@{}
foreach ($aliasNamespacePattern in "MyCallstack","Get-PSCallstack") {
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
}
foreach ($toCreateAlias in $aliasesToCreate.GetEnumerator()) {
    $aliasName, $aliasedTo = $toCreateAlias.Key, $toCreateAlias.Value 
    if ($aliasNamespaceSeparator -match '(?>\[|\<)$') {
        if ($matches.0 -eq '[') { $aliasName += ']' }
        elseif ($matches.0 -eq '<') { $aliasName += '>' }
    }
    Set-Alias $aliasName $commandToAlias
}



function Automatic.Variable.MySelf {
    <#
    .SYNOPSIS
        $MySelf
    .DESCRIPTION
        $MySelf is an automatic variable that contains the currently executing ScriptBlock.
        A Command can & $myself to use anonymous recursion.
    .EXAMPLE
        {
            $mySelf
        } | Use-PipeScript
    .EXAMPLE
        # By using $Myself, we can write an anonymously recursive fibonacci sequence.
        Invoke-PipeScript {
            param([int]$n = 1)
            if ($n -lt 2) {
                $n
            } else {
                (& $myself ($n -1)) + (& $myself ($n -2))
            }
        } -ArgumentList 10
    #>    
    $MyInvocation.MyCommand.ScriptBlock
}

