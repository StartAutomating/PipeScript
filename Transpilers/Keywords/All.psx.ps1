<#
.SYNOPSIS
    all keyword
.DESCRIPTION
    The all keyword is a powerful way to accomplish several useful scenarios with a very natural syntax.

    `all` can get all of a set of things that match a criteria and run one or more post-conditions.
.EXAMPLE
    & {
    $glitters = @{glitters=$true}
    all that glitters
    }.Transpile()
.EXAMPLE
    function mallard([switch]$Quack) { $Quack }
    Get-Command mallard | Get-Member  | Select-Object -ExpandProperty TypeName -Unique
    all functions that quack are ducks
    Get-Command mallard | Get-Member  | Select-Object -ExpandProperty TypeName -Unique
.EXAMPLE
    
    . {
        $numbers = 1..100
        $null = all $numbers where { ($_ % 2) -eq 1 } are odd
        $null = all $numbers where { ($_ % 2) -eq 0 } are even
    }.Transpile()

    @(
        . { all even $numbers }.Transpile()
    ).Length

    @(
        . { all odd $numbers }.Transpile()
    ).Length
    
    
#>

[ValidateScript({
    $validateVar = $_
    if ($validateVar -is [Management.Automation.Language.CommandAst]) {
        $cmdAst = $validateVar
        if ($cmdAst.CommandElements[0].Value -eq 'all') {
            return $true
        }
    }
    return $false
})]
[Reflection.AssemblyMetadata("PipeScript.Keyword",$true)]
param(
# The input to be searched.
[Parameter(ValueFromPipelineByPropertyName,Position=0)]
[Alias('In','Of', 'The','Object')]
$InputObject,

# If set, include all functions in the input.
[Alias('Function')]
[switch]
$Functions,

# If set, include all commands in the input.
[Alias('Command')]
[switch]
$Commands,

# If set, include all cmdlets in the input
[Alias('Cmdlet')]
[switch]
$Cmdlets,

# If set, include all aliases in the input
[Alias('Alias')]
[switch]
$Aliases,

# If set, include all applications in the input
[Alias('Application')]
[switch]
$Applications,

# If set, include all applications in the input
[Alias('ExternalScript','Script','ExternalScripts')]
[switch]
$Scripts,

# If set, include all variables in the inputObject.
[Parameter()]
[Alias('Variable')]
[switch]
$Variables,

# If set, will include all of the variables, aliases, functions, and scripts in the current directory.
[Parameter()]
[Alias('Thing')]
[switch]
$Things,

<#
A condition.

If the condition is a ScriptBlock, it will act similar to Where-Object.

If the condition is not a script block, the conditional will be inferred by the word choice.

For example:
~~~PowerShell
all functions matching PipeScript
~~~

will return all functions that match the pattern 'PipeScript'

Or:

~~~PowerShell
all in 1..100 greater than 50
~~~

will return all numbers in 1..100 that are greater than 50.

Often, these conditionals will be checked against multiple targets.

For example:

~~~PowerShell
all cmdlets that ID
~~~

Will check all cmdlets to see if:
* they are named "ID"
* OR they have members named "ID"
* OR they have parameters named "ID"
* OR their PSTypenames contains "ID"

#>
 
[Parameter(ValueFromPipelineByPropertyName,Position=1)]
[Alias(
    'That Are', 'That Have', 'That','Condition','Where-Object', 'With a', 'With the', 'With', 
    'That Match', 'Match', 'Matching',
    'That Matches','Match Expression','Match Regular Expression', 'Match Pattern', 'Matches Pattern',
    'That Are Like', 'Like', 'Like Wildcard',
    'Greater Than', 'Greater', 'Greater Than Or Equal', 'GT', 'GE',
    'Less Than', 'Less', 'Less Than Or Equal', 'LT', 'LE'
)]
$Where,

<#

An action that will be run on every returned item.

As with the -Where parameter, the word choice used for For can be impactful.

In most circumstances, passing a [ScriptBlock] will work similarly to a foreach statment.

When "Should" is present within the word choice, it attach that script as an expectation that can be checked later.

#>
[Parameter(ValueFromPipelineByPropertyName,Position=2)]
[Alias('Is','Are',
    'Foreach',
    'Foreach-Object',
    'Can',
    'And Can',
    'Could',
    'And Could',
    'Should',
    'And Should', 
    'Is A',
    'And Is A', 
    'Is An', 
    'And Is An',
    'Are a', 
    'And Are a',
    'Are an',
    'And Are An'
)]
$For,

# The way to sort data before it is outputted.
[Parameter(ValueFromPipelineByPropertyName,Position=3)]
[Alias('sorted by','sort by','sort on','sorted on','sorted','Sort-Object')]
$Sort,

# If output should be sorted in descending order.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('ascending')]
[switch]
$Descending,

# The Command AST.
# This parameter and parameter set are present so that this command can be transpiled from source, and are unlikely to be used. 
[Parameter(Mandatory,ParameterSetName='CommandAST',ValueFromPipeline)]
[Management.Automation.Language.CommandAst]
$CommandAst
)

begin {
    filter WhereValueToCondition
    {
        param($ClauseName)
        $parameterValue = $_
        if ($parameterValue -is [Management.Automation.Language.ScriptBlockExpressionAst]) {
            $parameterValue = $parameterValue.ConvertFromAST()
        }
        if (($parameterValue -isnot [Management.Automation.Language.VariableExpressionAst]) -and
            ($parameterValue -is [ScriptBlock] -or $parameterValue -is [Management.Automation.Language.Ast])
        ) {
            "if (-not `$($($parameterValue.Transpile())
)) { continue nextItem } "
        } else {
            $targetExpr = 
                if ($parameterValue -is [Management.Automation.Language.VariableExpressionAst]) {
                    "$parameterValue"
                } else {
                    "'$("$parameterValue".Replace("'","''"))'"
                }
            
            $operator, $notOperator, $flipOrder, $checkMembers, $checkParameters, $checkTypeName = 
                $null, $null       , $null     , $true        , $true           , $true

            switch -Regex ($clauseName) {
                # If the clause mentioned the word match
                "match" {
                    $operator, $notOperator, $flipOrder =
                        "match", "notmatch", $false
                }
                "like" {
                    $operator, $notOperator, $flipOrder =
                        "like", "notlike", $false
                }
                "(?>greater|^g[e|t]$)" {
                    $operator = "g$(if ($clauseName -match 'equal' -or $clauseName -eq 'ge') {
                        "e"
                    } else {
                        "t"
                    })"
                    $operator, $notOperator, $flipOrder, $checkMembers, $checkParameters, $checkTypeName =
                        "$operator", "$($operator -replace 'g','l')", $false, $false, $false, $false
                }
                "(?>less|^l[e|t]$)" {
                    $operator = "g$(if ($clauseName -match 'equal' -or $clauseName -eq 'le') {
                        "e"
                    } else {
                        "t"
                    })"
                    $operator, $notOperator, $flipOrder, $checkMembers, $checkParameters, $checkTypeName =
                        "$operator", "$($operator -replace 'g','l')", $false, $false, $false, $false
                }                    
                default {
                    $operator, $notOperator, $flipOrder =
                        "eq", "ne", $true
                }
            }
            $itemOperatorCheck = 
                if (-not $flipOrder) {
                    "(`$item -$operator $targetExpr)"
                } else {
                    "($targetExpr -$operator `$item)"
                }

            $fuzzyChecks = @(
                "# If the item stringify's to the value", "$itemOperatorCheck" -join [Environment]::NewLine

                if ($checkMembers) {
                    "# or it has a member $Operator the value", "(`$item.psobject.Members.Name -$operator $targetExpr)" -join [Environment]::NewLine
                }
                
                if ($checkParameters) {
                    "# or it has a Parameter $Operator the value", "(`$item.Parameters.Keys -$operator $targetExpr)" -join [Environment]::NewLine
                }
                
                if ($checkTypeName) {
                    "# or it's typenames are named $targetExpr","(`$item.pstypenames -$operator $targetExpr)" -join [Environment]::NewLine
                }
            ) -join (" -or" + [Environment]::NewLine)
"

# Interpreting $targetExpr with fuzzy logic        
if (-not (
    $fuzzyChecks
)) {    
continue nextItem # keep moving
}"
        }
    }        
    

    filter ForValueToAction {
        param($ClauseName)        
        $forValue = $_
        $forCount++        

        if ($forValue -is [Management.Automation.Language.ScriptBlockExpressionAst]) {
            $forValue = $forValue.ConvertFromAST()
        }
        if (($forValue -isnot [Management.Automation.Language.VariableExpressionAst]) -and
            ($forValue -is [ScriptBlock] -or $forValue -is [Management.Automation.Language.Ast])
        ) {
            switch -Regex ($clauseName) {
                Should {
                    "
                    # When we say all ... should, we're setting an expectation:
                    `$expectation = {
                        $($forValue.Transpile())
                    }
                    # If the object did not have an expectations property
                    if (-not `$item.psobject.Properties['.ShouldBe']) {
                        # create an empty list
                        `$item.psobject.Properties.add([psnoteproperty]::new('.ShouldBe', @()))
                    }

                    # If the object has an expectations property, see if this expectation is already set.
                    if (`$item.psobject.Properties['.ShouldBe'] -and 
                        `$item.'.ShouldBe' -as [string[]] -notcontains `"`$expectation`") {
                        `$item.'.ShouldBe' += `$expectation
                    }
                    "
                }                
                default {
                    $forHasOutput = $true
                    "$($forValue.Transpile())"
                }
            }            
        } else {
            $targetExpr = 
                if ($forValue -is [Management.Automation.Language.VariableExpressionAst]) {
                    "$forValue"
                } else {
                    "'$("$forValue".Replace("'","''"))'"
                }

            switch -Regex ($clauseName) {
                Should {
    "
    # When we say all ... should, we're setting an expectation:    
    # If the object did not have an expectations property
    if (-not `$item.psobject.Properties['.ShouldBe']) {
        # create an empty list
        `$item.psobject.Properties.add([psnoteproperty]::new('.ShouldBe', @()))
    }

    # If the object has an expectations property, see if this expectation is already set.
    if (`$item.psobject.Properties['.Should'] -and 
        `$item.'.ShouldBe' -as [string[]] -notcontains $targetExpr) {
        `$item.'.ShouldBe' += $targetExpr
    }
    "
                }
                default {
"
$(if ($forValue -is [Management.Automation.Language.VariableExpressionAst]) {
"if ($targetExpr -is [ScriptBlock] -or 
    $targetExpr -is [Management.Automation.CommandInfo]) {
    & $targetExpr
}
else"
})$(if ($variable -or $Things) {   
"if (`$item.value -and `$item.value.pstypenames.insert) {
    if (`$item.value.pstypenames -notcontains $targetExpr) {
        `$item.value.pstypenames.insert(0, $targetExpr)
    }
}
else"})if (`$item.pstypenames.insert -and `$item.pstypenames -notcontains $targetExpr) {
    `$item.pstypenames.insert(0, $targetExpr)
}
"
                }
            }
        }

        # If the For does not have an expression that could output
        # and we are on the last item
        # output the item.
        if (-not $ForHasOutput -and ($forCount -eq $forLength)) {"`$item"}
        
    }
}

process {    
    # Gather some information about our calling context
    $myParams = [Ordered]@{} + $PSBoundParameters
    # and attempt to parse it as a sentance (only allowing it to match this particular command)
    $mySentence = $commandAst.AsSentence($MyInvocation.MyCommand)   
    $myCmd = $MyInvocation.MyCommand
    $myCmdName = $myCmd.Name

    # Determine how many times we've been recursively called, so we can disambiguate variables later.
    $callstack       = Get-PSCallStack
    $callCount       = @($callstack | 
        Where-Object { $_.InvocationInfo.MyCommand.Name -eq $myCmdName}).count - 1

    # Unset the value for each parameter variable, to avoid pipeline stickiness problems.
    foreach ($parameterMetadata in ($MyInvocation.MyCommand -as [Management.Automation.CommandMetadata]).Parameters.Values) {
        if (-not $parameterMetadata.Attributes.Mandatory) {
            $ExecutionContext.SessionState.PSVariable.Set($parameterMetadata.Name, $null)
        }
    }

    # Walk thru all mapped parameters in the sentence
    $SetVariableErrors = @{}
    foreach ($paramName in $mySentence.Parameters.Keys) {
        if (-not $myParams[$paramName]) { # If the parameter was not directly supplied
            $myParams[$paramName] = $mySentence.Parameters[$paramName] # grab it from the sentence.
            foreach ($myParam in $myCmd.Parameters.Values) {
                if ($myParam.Aliases -contains $paramName) { # set any variables that share the name of an alias
                    $ExecutionContext.SessionState.PSVariable.Set($myParam.Name, $mySentence.Parameters[$paramName])
                }
            }
            # and try to set this variable for this value.
            try {
                $ExecutionContext.SessionState.PSVariable.Set($paramName, $mySentence.Parameters[$paramName])
            } catch {
                $SetVariableErrors[$paramName] = $_
            }
        }
    }

    $impliedFor   = @()
    $impliedWhere = @()

    # Now all of the remaining code in this transpiler should act as if we called it from the command line.

    # Nowe we need to set up the input set
    $inputSet = @(        
        $commandTypes = [Management.Automation.CommandTypes]0
        foreach ($myParam in $myCmd.Parameters.Values) {
            if ($myParam.ParameterType -eq [switch] -and 
                $ExecutionContext.SessionState.PSVariable.Get($myParam.Name).Value) {
                if ($myParam.Name -replace 'e?s$' -as [Management.Automation.CommandTypes]) {
                    $commandTypes = $commandTypes -bor [Management.Automation.CommandTypes]($myParam.Name -replace 'e?s$')
                }
                elseif ($myParam.Name -eq 'Things') {
                    $commandTypes = $commandTypes -bor [Management.Automation.CommandTypes]'Alias,Function,Filter,Cmdlet'
                }                
                elseif ($myParam.Name -eq 'Commands') {
                    $commandTypes = 'All'
                }
            }
        }    

        if ($commandTypes) {
            [ScriptBlock]::create("`$executionContext.SessionState.InvokeCommand.GetCommands('*','$commandTypes',`$true)")
        }
        if ($variables -or $Things) {
            {Get-ChildItem -Path variable:}
        }
        if ($InputObject) {
            $InputObjectToInclude = 
                if ($InputObject -is [Management.Automation.Language.Ast]) {
                    if ($InputObject -is [Management.Automation.Language.ScriptBlockExpressionAst]) {
                        $InputObject.ConvertFromAST()
                    } else {
                        $InputObject.Extent.ToString()
                    }
                } 
                elseif ($InputObject -is [scriptblock]) {
                    "& {$($InputObject)}"
                }
                else {
                    $InputObject
                }

            if ($Scripts) {
                "($InputObjectToInclude |" + {
    & { process {
        $inObj = $_
        if ($inObj -is [Management.Automation.CommandInfo]) {
            $inObj
        }
        elseif ($inObj -is [IO.FileInfo] -and $inObj.Extension -eq '.ps1') {
            $ExecutionContext.SessionState.InvokeCommand.GetCommand($inObj.Fullname, 'ExternalScript')
        }
        elseif ($inObj -is [string] -or $inObj -is [Management.Automation.PathInfo]) {
            $resolvedPath = $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($inObj)
            if ($resolvedPath) {
                $pathItem = Get-item -LiteralPath $resolvedPath
                if ($pathItem -is [IO.FileInfo] -and $pathItem.Extension -eq '.ps1') {
                    $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'ExternalScript')
                } else {                    
                    foreach ($pathItem in @(Get-ChildItem -LiteralPath $pathItem -File -Recurse)) {
                        if ($pathItem.Extension -eq '.ps1') {
                            $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'ExternalScript')
                        }
                    }
                }
            }            
        }
    } }
} + ')'
            } else {
                $InputObjectToInclude
            }
        }
    )

    # If the sentence had unbound arguments
    if ($mySentence.Arguments) {
        if (-not $inputSet) { # and we had not yet set input
            $inputSet = 
                foreach ($sentanceArg in $mySentence.Arguments) {
                    # then anything that is not a [string] or [ScriptBlock] will become input
                    if ($sentanceArg -isnot [string] -and $sentanceArg -isnot [ScriptBlock]) {
                        $sentanceArg
                    } else {
                        # and [strings]s and [ScriptBlock]s will become -Where parameters.
                        $impliedWhere += $sentanceArg                        
                    }
                }
        } else {
            foreach ($sentenceArg in @($mySentence.Arguments)) {
                if (-not $sentenceArg) { continue }
                if ($sentenceArg -is [ScriptBlock] -and 
                    -not ($mySentence.Clauses.ParameterName -eq 'InputObject')) {
                    $impliedFor += $sentanceArg                    
                } else {
                    $impliedWhere += $sentanceArg
                }
            }
        }
    }

    if ($CommandAst.IsPiped) {
        if ($inputSet) {
            $inputSet = @({$_}) + $inputSet
        } else {
            $inputSet = @({$_})
        }
    }

    
    if (-not $InputSet) {
        # If we still don't have an input set, grab any variables from the arguments.
        $InputSet =
            if ($mySentence.Arguments) {
                foreach ($sentenceArg in $mySentence.Arguments) {
                    if ($sentenceArg -is [Management.Automation.Language.VariableExpressionAst]) {
                        $sentenceArg
                    }
                }
            }
        # If we still don't have an inputset, default it to 'things'
        if (-not $inputSet) {
            $Things = $true
            $inputSet = @(
                {$ExecutionContext.SessionState.InvokeCommand.GetCommands('*', 'Alias,Function,Filter,Cmdlet', $true)}, 
                {Get-ChildItem -Path variable:}
            )
        }            
    }


    $InputCollectionScript = "@($(
        $inputSet -join ([Environment]::NewLine + '   ')
    ))"
    
    # Note: there's still a lot of room for this syntax to grow and become even more natural.
    
    # But with most of our arguments in hand, now we're ready to create the script

    #region Generate Script
    $generatedScript = @(

    # Create an input collection with all of our input.

    # If we're just getting, we don't need to assign this
    if (-not ($Where -or $For -or $impliedFor -or $sort -or $impliedWhere)) {
        $InputCollectionScript
    } else {        
        '
        # Collect all items into an input collection
        $inputCollection = ' + $InputCollectionScript
    }


if ($Where -or $impliedWhere) {
    $whereClauses = 
        @(
        if ($impliedWhere) {
            $impliedWhere | WhereValueToCondition
        }
        foreach ($clause in $mySentence.Clauses) { 
            if ($clause.ParameterName -ne 'Where') { continue }

            foreach ($parameterValue in $clause.ParameterValues) {             
                $parameterValue | WhereValueToCondition -ClauseName $clause.Name
            }            
        })
    
@(
    # If -Where was provided, filter the input

"
# Since filtering conditions have been passed, we must filter item-by-item
`$filteredCollection = :nextItem foreach (`$item in `$inputCollection) {
    # we set `$this, `$psItem, and `$_ for ease-of-use.
    `$this = `$_ = `$psItem = `$item 
    $(if ($Variables -or $Things) {
    "
    # Some of the items may be variables.
    if (`$item -is [Management.Automation.PSVariable]) {
        # In this case, reassign them to their value.
        `$this = `$_ = `$psItem = `$item = `$item.Value
    }

    # Some variables may be dictionaries,
    # but it will be easier to look at everything as an object.
    if (`$item -is [Collections.IDictionary]) {
        `$item = [PSCustomObject]`$item
    }
    "
    }) 
        
    $($whereClauses -join ([Environment]::NewLine + (' ' * 4)))
    
    `$item
    "    
    
"
    
}"
)
}

if ($Sort) {
    # If -Sort was specified, we generate code to walk over each sorted item.
    $actualSort =
        @(foreach ($sorter in $sort) {
            if ($sorter -is [string]) {
               "'$($sorter -replace "'","''")'" 
            } elseif ($sorter -is [Management.Automation.Language.ScriptBlockExpressionAst]) {
                "{$($sorter.ConvertFromAST.Transpile())}"
            } elseif ($sorter -is [Management.Automation.Language.HashtableAst]) {
                $sorter.Extent.ToString()
            }
        }) -join ','

"
`$filteredCollection = `$filteredCollection | Sort-Object $Sort$(if ($Descending) { ' -Descending'})
"
}

if ($For -or $impliedFor) {
    $forClauses = @($impliedFor) + @(
        foreach ($clause in $mySentence.Clauses) { 
            if ($clause.ParameterName -ne 'For') { continue }
            $clause.ParameterValues
        }
    )
    $forClauses = @($forClauses | Select-Object -Unique)
    $forLength = $forClauses.Length
    $forCount  = 0
    $forHasOutput = $false
    $forClauses = @(                
        if ($impliedFor) {
            $impliedFor | . ForValueToAction
        }
        foreach ($clause in $mySentence.Clauses) { 
            if ($clause.ParameterName -ne 'For') { continue }
            
            foreach ($forValue in $clause.ParameterValues) {
                if ($impliedFor -contains $forValue) { continue }
                $forValue | . ForValueToAction -ClauseName $clause.Name
            }
        }        
    )    
$collectionVariable = if (-not ($Where -or $Sort)) {
    '$inputCollection'
} else {
    '$filteredCollection'
}
# If -For was specified, we generate code to walk over each item in the filtered collection
"
# Walk over each item in the filtered collection
foreach (`$item in $collectionVariable) {
    # we set `$this, `$psItem, and `$_ for ease-of-use.
    `$this = `$_ = `$psItem = `$item
    $($forClauses -join ([Environment]::NewLine + (' ' * 4))) 
}   
"    
} elseif ($where -or $Sort -or $for) {
    "`$filteredCollection"        
}
)

    #endregion Generate Script

    # If the command was assigned or piped from, wrap the script in a subexpression
    if ($CommandAst.IsAssigned -or $CommandAst.PipelinePosition -lt $CommandAst.PipelineLength) {
        $generatedScript = 
            if ($generatedScript.Length -gt 1) {
                "`$($($generatedScript -join [Environment]::NewLine))"
            } else {
                "$generatedScript"
            }
        
    }
    # If the command was piped to, wrap the script in a command expression.
    if ($CommandAst.IsPiped) {
        $generatedScript = "& { process {
$generatedScript
} }"  
    }
    
    # Generate the scriptblock
    $generatedScript = [ScriptBlock]::create(
        $generatedScript -join [Environment]::NewLine
    )
    
    if (-not $generatedScript) { return } 
    Update-PipeScript -RenameVariable @{
        'item' = "$('_' * $callcount)item"
        "filteredCollection" = "$('_' * $callcount)filteredCollection"
        "inputCollection"  = "$('_' * $callcount)inputCollection"
    } -ScriptBlock $generatedScript
}