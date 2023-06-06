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

# An optional condition
[Parameter(ValueFromPipelineByPropertyName,Position=1)]
[Alias(
    'That Are', 'That Have', 'That','Condition','Where-Object', 'With a', 'With the', 'With', 
    'That Match', 'Match', 'Matching',
    'That Matches','Match Expression','Match Regular Expression', 'Match Pattern', 'Matches Pattern',
    'That Are Like', 'Like', 'Like Wildcard'
)]
$Where,

# The action that will be run
[Parameter(ValueFromPipelineByPropertyName,Position=2)]
[Alias('Is','Are',
    'Foreach',
    'Foreach-Object',
    'Can',
    'Could',
    'Should', 
    'Is A', 
    'Is An', 
    'Are a', 
    'Are an'
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

# The Command AST
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
"

# Interpreting $targetExpr with fuzzy logic        
if (-not (
$itemOperatorCheck -or                           # If the item stringify's to the value
(`$item.psobject.properties.Name -$operator $targetExpr) -or  # or has a $targetExpr property
(`$item.Parameters.Keys -$operator $targetExpr) -or           # or it's parameters are named $targetExpr
(`$item.pstypenames -$operator $targetExpr)                   # or it's typenames are named $targetExpr
)) {    
continue nextItem # keep moving
}"
        }
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

    foreach ($parameterMetadata in ($MyInvocation.MyCommand -as [Management.Automation.CommandMetadata]).Parameters.Values) {
        if (-not $parameterMetadata.Attributes.Mandatory) {
            $ExecutionContext.SessionState.PSVariable.Set($parameterMetadata.Name, $null)
        }
    }

    # Walk thru all mapped parameters in the sentence
    foreach ($paramName in $mySentence.Parameters.Keys) {
        if (-not $myParams[$paramName]) { # If the parameter was not directly supplied
            $myParams[$paramName] = $mySentence.Parameters[$paramName] # grab it from the sentence.
            foreach ($myParam in $myCmd.Parameters.Values) {
                if ($myParam.Aliases -contains $paramName) { # set any variables that share the name of an alias
                    $ExecutionContext.SessionState.PSVariable.Set($myParam.Name, $mySentence.Parameters[$paramName])
                }
            }
            # and set this variable for this value.
            $ExecutionContext.SessionState.PSVariable.Set($paramName, $mySentence.Parameters[$paramName])
        }
    }
    
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
                        if (-not $Where) {
                            $Where = $sentanceArg
                        }
                        else {
                            $where = @($Where) + $sentanceArg
                        }
                    }
                }
        } else {
            foreach ($sentenceArg in @($mySentence.Arguments)) {
                if (-not $sentenceArg) { continue }
                if ($sentenceArg -is [ScriptBlock] -and 
                    -not ($mySentence.Clauses.ParameterName -eq 'InputObject')) {
                    if (-not $For) {
                        $for = $sentenceArg
                    } else {
                        $for = @($for) + $sentenceArg
                    }
                } else {
                    if (-not $Where) {
                        $Where = $sentenceArg
                    }
                    else {
                        $where = @($Where) + $sentenceArg
                    }
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
    if (-not ($Where -or $For -or $sort)) {
        $InputCollectionScript
    } else {        
        '
        # Collect all items into an input collection
        $inputCollection = ' + $InputCollectionScript
    }


if ($Where) {
    $whereClauses = 
        @(
        if ($mySentence.Arguments) {
            $where | WhereValueToCondition
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

if ($For) {

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
"
    $forLength = @($for).Length
    $forCount  = 0 
    foreach ($fo in $for) {
        $forCount++
        if ($fo -is [Management.Automation.Language.ScriptBlockExpressionAst]) {
            $fo = $fo.ConvertFromAST()
        }
        
        if ($fo -is [ScriptBlock] -or $fo -is [Management.Automation.Language.Ast]) {
            $fo.Transpile()
        }

        if ($fo -is [string]) {
            $safeStr = $fo -replace "'", "''"
            "
$(if ($variable) {
"if (`$item.value -and `$item.value.pstypenames.insert) {
    if (`$item.value.pstypenames -notcontains '$safeStr') {
        `$item.value.pstypenames.insert(0, '$safeStr')
    }
}
else"})if (`$item.pstypenames.insert -and `$item.pstypenames -notcontains '$safeStr') {
    `$item.pstypenames.insert(0, '$safeStr')
}
$(if ($forCount -eq $forLength) {"`$item"})
"
        }

    }

"
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