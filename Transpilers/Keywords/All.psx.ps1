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
    . {all functions that quack are ducks}.Transpile()
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

using namespace System.Management.Automation.Language

[ValidateScript({
    $validateVar = $_
    if ($validateVar -is [CommandAst]) {
        $cmdAst = $validateVar
        if ($cmdAst.CommandElements[0].Value -eq 'all') {
            return $true
        }
    }
    return $false
})]
[Reflection.AssemblyMetadata("PipeScript.Keyword",$true)]
param(
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

# The input to be searched.
[Parameter(ValueFromPipelineByPropertyName,Position=0)]
[Alias('In','Of', 'The','Object')]
$InputObject,

# An optional condition
[Parameter(ValueFromPipelineByPropertyName,Position=1)]
[Alias('That Are', 'That Have', 'That','Condition','Where-Object', 'With a', 'With the', 'With')]
$Where,

# The action that will be run
[Parameter(ValueFromPipelineByPropertyName,Position=2)]
[Alias('Is','Are','Foreach','Foreach-Object','Can','Could','Should')]
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
[CommandAst]
$CommandAst
)

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
                elseif ($myParam.Name -eq 'Scripts') {
                    $commandTypes = $commandTypes -bor [Management.Automation.CommandTypes]'ExternalScript'
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
            if ($InputObject -is [Ast]) {
                if ($InputObject -is [ScriptBlockExpressionAst]) {
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

    # Note: there's still a lot of room for this syntax to grow and become even more natural.
    
    # But with most of our arguments in hand, now we're ready to create the script

    #region Generate Script
    $generatedScript = @(

    # Create an input collection with all of our input
'
# Collect all items into an input collection
$inputCollection =' + $(
    @(foreach ($setOfInput in $inputSet) {
        if ($setOfInput -is [ScriptBlock]) {
            '$(' + [Environment]::NewLine + 
            $setOfInput + [Environment]::NewLine + ')'
        } else {
            "`$($setOfInput)"
        }
    }) -join (',' + [Environment]::NewLine + '   ')
)

"
# 'unroll' the collection by iterating over it once.
`$filteredCollection = `$inputCollection =
    @(foreach (`$in in `$inputCollection) {
        `$in
    })
"

if ($Where) {
@(
    # If -Where was provided, filter the input

"
# Since filtering conditions have been passed, we must filter item-by-item
`$filteredCollection = :nextItem foreach (`$item in `$inputCollection) {
    # we set `$this, `$psItem, and `$_ for ease-of-use.
    `$this = `$_ = `$psItem = `$item
 
    # Some of the items may be variables.
    if (`$item -is [Management.Automation.PSVariable]) {
        # In this case, reassign them to their value.
        `$this = `$_ = `$psItem = `$item = `$item.Value
    }
    
    # Some of the items may be enumerables
    `$unrolledItems = 
        if (`$item.GetEnumerator -and `$item -isnot [string]) {
            @(`$item.GetEnumerator())
        } else {
            `$item
        }
    foreach (`$item in `$unrolledItems) {
        `$this = `$_ = `$psItem = `$item
        $(
            foreach ($wh in $where) {
                if ($wh -is [ScriptBlockExpressionAst]) {
                    $wh = $wh.ConvertFromAST()
                }
                if ($wh -is [ScriptBlock] -or $wh -is [Ast]) {
                    "if (-not `$($($wh.Transpile())
        )) { continue } "
                }
                elseif ($wh -is [string]) {
                    $safeStr = $($wh -replace "'", "''")
                    "if (-not (                                          # Unless it 
                        (`$null -ne `$item.'$safeStr') -or               # has a '$safeStr' property                
                        (`$null -ne `$item.Parameters.'$safeStr') -or    # or it's parameters have the property '$safeStr'
                        (`$item.pstypenames -contains '$safeStr')        # or it's typenames have the property '$safeStr'
        )) {    
            continue # keep moving
        }"
                }
            }
        )
        `$item
    }
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
            } elseif ($sorter -is [ScriptBlockExpressionAst]) {
                "{$($sorter.ConvertFromAST.Transpile())}"
            } elseif ($sorter -is [HashtableAst]) {
                $sorter.Extent.ToString()
            }
        }) -join ','

"
`$filteredCollection = `$filteredCollection | Sort-Object $Sort$(if ($Descending) { ' -Descending'})
"
}

if ($For) {
# If -For was specified, we generate code to walk over each item in the filtered collection
"
# Walk over each item in the filtered collection
foreach (`$item in `$filteredCollection) {
    # we set `$this, `$psItem, and `$_ for ease-of-use.
    `$this = `$_ = `$psItem = `$item
"
    foreach ($fo in $for) {
        if ($fo -is [ScriptBlockExpressionAst]) {
            $fo = $fo.ConvertFromAST()
        }
        
        if ($fo -is [ScriptBlock] -or $fo -is [Ast]) {
            $fo.Transpile()
        }

        if ($fo -is [string]) {
            $safeStr = $fo -replace "'", "''"
            "
if (`$item.value -and `$item.value.pstypenames.insert) {
    if (`$item.value.pstypenames -notcontains '$safeStr') {
        `$item.value.pstypenames.insert(0, '$safeStr')
    }
}
elseif (`$item.pstypenames.insert -and `$item.pstypenames -notcontains '$safeStr') {
    `$item.pstypenames.insert(0, '$safeStr')
}
`$item
            "
        }

    }

"
}
"    
} else {
    "`$filteredCollection"        
}
)

    #endregion Generate Script

    # If the command was assigned or piped from, wrap the script in a subexpression
    if ($CommandAst.IsAssigned -or $CommandAst.PipelinePosition -lt $CommandAst.PipelineLength) {
        $generatedScript = "`$($($generatedScript -join [Environment]::NewLine))"
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

    # Rename the variables in the generated script, using our callstack count.
    .>RenameVariable -ScriptBlock $generatedScript -VariableRename @{
        'item' = "$('_' * $callcount)item"
        "filteredCollection" = "$('_' * $callcount)filteredCollection"
        "inputCollection"  = "$('_' * $callcount)inputCollection"
    }
}