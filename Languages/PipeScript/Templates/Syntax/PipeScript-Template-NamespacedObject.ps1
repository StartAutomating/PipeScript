[ValidatePattern('PipeScript')]
param()


function Template.PipeScript.NamespacedObject {

    <#
    .SYNOPSIS
        Namespaced functions
    .DESCRIPTION
        Allows the declaration of a object or singleton in a namespace.
        
        Namespaces are used to logically group functionality and imply standardized behavior.    
    .EXAMPLE
        Invoke-PipeScript {
            My Object Precious { $IsARing = $true; $BindsThemAll = $true }
            My.Precious
        }
    #>
    [Reflection.AssemblyMetaData('Order', -10)]
    [ValidateScript({
        # This only applies to a command AST
        $cmdAst = $_ -as [Management.Automation.Language.CommandAst]
        if (-not $cmdAst) { return $false }
        # It must have at 4-5 elements.
        if ($cmdAst.CommandElements.Count -lt 4 -or $cmdAst.CommandElements.Count -gt 5) {
            return $false
        }
        # The second element must be a function or filter.
        if ($cmdAst.CommandElements[1].Value -notin 'object', 'singleton') {
            return $false
        }
        # The third element must be a bareword
        if ($cmdAst.CommandElements[1].StringConstantType -ne 'Bareword') {
            return $false
        }

        # The last element must be a ScriptBlock or HashtableAst
        if (
            $cmdAst.CommandElements[-1] -isnot [Management.Automation.Language.ScriptBlockExpressionAst] -and
            $cmdAst.CommandElements[-1] -isnot [Management.Automation.Language.HashtableAst]
        ) {
            return $false
        }

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
    # Namespaced functions are really simple:

    # We use multiple assignment to pick out the parts of the function
    $namespace, $objectType, $functionName, $objectDefinition = $CommandAst.CommandElements    

    # Then, we determine the last punctuation.
    $namespaceSeparatorPattern = [Regex]::new('[\p{P}<>]{1,}','RightToLeft')    
    $namespaceSeparator = $namespaceSeparatorPattern.Match($namespace).Value
    # If there was no punctuation, the namespace separator will be a '.'
    if (-not $namespaceSeparator) {$namespaceSeparator = '.'}
    # If the pattern was empty brackets `[]`, make the separator `[`.
    elseif ($namespaceSeparator -eq '[]') { $namespaceSeparator = '[' }
    # If the pattern was `<>`, make the separator `<`.
    elseif ($namespaceSeparator -eq '<>') { $namespaceSeparator = '<' }

    # Replace any trailing separators from the namespace.
    $namespace = $namespace -replace "$namespaceSeparatorPattern$"

    $blockComments = ''
    
    $defineInstance = 
        if ($objectDefinition -is [Management.Automation.Language.HashtableAst]) {
            "[PSCustomObject][Ordered]$($objectDefinition)"
        }
        elseif ($objectDefinition -is [Management.Automation.Language.ScriptBlockExpressionAst]) {
            $findBlockComments = [Regex]::New("
            \<\# # The opening tag
            (?<Block>
                (?:.|\s)+?(?=\z|\#>) # anything until the closing tag
            )
            \#\> # the closing tag
            ", 'IgnoreCase,IgnorePatternWhitespace', '00:00:01')
            $foundBlockComments = $objectDefinition -match $findBlockComments
            if ($foundBlockComments -and $matches.Block) {
                $blockComments = $null,"<#",$($matches.Block),"#>",$null -join [Environment]::Newline
            }
            "New-Module -ArgumentList @(@(`$input) + @(`$args)) -AsCustomObject $objectDefinition"
        }

    
    # Join the parts back together to get the new function name.
    $NewFunctionName = $namespace,$namespaceSeparator,$functionName,$(
        # If the namespace separator ends with `[` or `<`, try to close it
        if ($namespaceSeparator -match '[\[\<]$') {
            if ($matches.0 -eq '[') { ']' }
            elseif ($matches.0 -eq '<') { '>' }
        }
    ) -ne '' -join ''

    $objectDefinition = "{
$($objectDefinition -replace '^\{' -replace '\}$')
Export-ModuleMember -Function * -Alias * -Cmdlet * -Variable *
}"

    $objectDefinition = 
        if ($objectType -eq "singleton") {
            "{$(if ($blockComments) {$blockComments})
$(
    @('$this = $myInvocation.MyCommand'
        'if (-not $this.Instance) {'
            "`$singletonInstance = $defineInstance"
            '$singletonInstance.pstypenames.clear()'            
            "`$singletonInstance.pstypenames.add('$($NewFunctionName -replace "'","''")')"
            "`$singletonInstance.pstypenames.add('$($namespace -replace $namespaceSeparatorPattern -replace "'","''")')"
            'Add-Member -InputObject `$this -MemberType NoteProperty -Name Instance -Value $singletonInstance -Force'
        '}'
        '$this.Instance'
    ) -join [Environment]::newLine
)
    
}"
        } else {
            "{
$(if ($blockComments) {$blockComments})
`$Instance = $defineInstance
`$Instance.pstypenames.clear()
`$Instance.pstypenames.add('$($NewFunctionName -replace "'","''")')
`$Instance.pstypenames.add('$($namespace -replace $namespaceSeparatorPattern -replace "'","''")')
`$Instance
}"
        }
    

        # Redefine the function
        $redefined = [ScriptBlock]::Create("
function $NewFunctionName $objectDefinition
")
        # Return the transpiled redefinition.
        $redefined | .>Pipescript
    }


}

