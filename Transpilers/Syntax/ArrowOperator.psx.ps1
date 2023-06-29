<#
.SYNOPSIS
    Arrow Operator
.DESCRIPTION
    Many languages support an arrow operator natively.  PowerShell does not.

    PipeScript's arrow operator works similarly to lambda expressions in C# or arrow operators in JavaScript:
.EXAMPLE
    $allTypes = 
        Invoke-PipeScript {
            [AppDomain]::CurrentDomain.GetAssemblies() => $_.GetTypes()
        }

    $allTypes.Count # Should -BeGreaterThan 1kb
    $allTypes # Should -BeOfType ([Type])
.EXAMPLE    
    Invoke-PipeScript {
        Get-Process -ID $PID => ($Name, $Id, $StartTime) => { "$Name [$ID] $StartTime"}
    } # Should -Match "$pid"
.EXAMPLE
    Invoke-PipeScript {
        func => ($Name, $Id) { $Name, $Id}
    } # Should -BeOfType ([ScriptBlock])
#>
[ValidatePattern("=>")]
[ValidateScript({
    $ToValidate = $_        
    if ($ToValidate -isnot [Management.Automation.Language.AssignmentStatementAst]) {
        return (
            $ToValidate -is [Management.Automation.Language.CommandAst]
        ) -and ($ToValidate.CommandElements.Value -eq '=>')        
    } else {
        return (
            $ToValidate.Right -is [Management.Automation.Language.PipelineAst]
        ) -and
        $ToValidate.Right.PipelineElements[0].CommandElements -and
        ('>' -eq $ToValidate.Right.PipelineElements[0].CommandElements[0])    
    }    
})]
param(
<# 
The Arrow Operator can be part of a statement, for example:

~~~PowerShell
Invoke-PipeScript { [AppDomain]::CurrentDomain.GetAssemblies() => $_.GetTypes() } 
~~~

The -ArrowStatementAst is the assignment statement that uses the arrow operator.
#> 
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='AssignmentStatementAst')]
[Management.Automation.Language.AssignmentStatementAst]
$ArrowStatementAst,

<#
The Arrow Operator can occur within a command, for example:

~~~PowerShell
Invoke-PipeScript {
    Get-Process -Id $pid => ($Name,$ID,$StartTime) => { "$Name [$ID] @ $StartTime" }
}
~~~
#>
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='CommandAst')]
[Management.Automation.Language.CommandAst]
$ArrowCommandAst
)

begin {
    # Declare a little script to help us turn things into parameters    
    $ConvertParensAndVariablesExpressionToParameters = {
        # If we have a parenthesis
        @(if ($currentParenthesis -and $currentParenthesis.Pipeline.PipelineElements) {
            $currentPipelineElement = $currentParenthesis.Pipeline.PipelineElements[0]
            if ($currentPipelineElement.Expression -is 
                [Management.Automation.Language.ArrayLiteralAst]) {
                # unroll array elements
                foreach ($arrayElement in $currentPipelineElement.Expression.Elements) {
                    if ($arrayElement -is [Management.Automation.Language.VariableExpressionAST]) {
                        "[Parameter(ValueFromPipelineByPropertyName)]$arrayElement"
                    } else {
                        "$arrayElement"
                    }
                }
            } elseif ($currentPipelineElement.Expression -is 
                [Management.Automation.Language.VariableExpressionAST]
            ) {
                # Put variables in directly if there was only one.
                "[Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]$currentPipelineElement"
            } elseif ($currentPipelineElement.Expression -is 
                [Management.Automation.Language.AttributedExpressionAst]) {
                # If the variable had attributes, make sure it has ValueFromPipelineByPropertyName
                if ($currentPipelineElement.Expression.Extent -notmatch '\[Parameter') {
                    "[Parameter(ValueFromPipelineByPropertyName)]$currentPipelineElement"
                } else {
                    "$currentPipelineElement"
                }
            } else {
                # Otherwise something unexpected came thru.  Do nothing.
                $null = $null
            }
            
        } elseif ($currentVariable) {
            # If there was a current single variable, bind it to the pipeline
            "[Parameter(ValueFromPipeline)]$currentVariable"
        }) -join ("," + [Environment]::Newline + (' ' * 8))
    }
}

process {
    $IsGeneratingALambda = $false
    $functionNames       = @()
    
    # Start generating our pipeline:
    $generatedPipeline = @(        
    
    # If we're in an assignment
    if ($ArrowStatementAst) {        
        if ($ArrowStatementAst.Left.VariablePath.DriveName -eq 'function' -or
            $ArrowStatementAst.Left.VariablePath.UserPath -eq 'function') {
            $IsGeneratingALambda = $true
        }

        "$($ArrowStatementAst.Left)" # the pipeline starts with the left

        $arrowPipeline = $ArrowStatementAst.Right
        
        # and we have a pipeline command 
        $arrowPipelineCommand = $arrowPipeline.PipelineElements[0]
        # whose first index we can skip (because it will be `>`).
        $arrowIndex = 1
    } elseif ($ArrowCommandAst) {
        # If we're part of a command ast
        $arrowPipelineCommand = $ArrowCommandAst
        $arrowCommandElements = # get all elements before this point
            @(for ($arrowIndex = 0; $arrowIndex -lt $arrowPipelineCommand.CommandElements.Count; $arrowIndex++) {
                $arrowElement = $arrowPipelineCommand.CommandElements[$arrowIndex]
                if ($arrowElement.Value -and $arrowElement.Value -eq 'func') {
                    $IsGeneratingALambda = $true
                    break
                }
                if ($arrowElement.Value -and $arrowElement.Value -eq '=>') {
                    break
                }
                $arrowElement            
            }) -join ' '

        # If there were any, start off our pipeline with this
        if ($arrowCommandElements) {
            $arrowCommandElements
        }
    }
    )

    # Now we need to go thru everything in the command after =>

    # Parenethesis, variables, and conditions are special, so nullify each.
    $currentParenthesis   = $null
    $currentVariable      = $null
    $IsCondition          = $false
    # Walk thru each command element.
    for (; $arrowIndex -lt $arrowPipelineCommand.CommandElements.Count; $arrowIndex++) {
        $arrowElement = $arrowPipelineCommand.CommandElements[$arrowIndex]
        # Track paranethesis
        if ($arrowElement -is [Management.Automation.Language.ParenExpressionAst]) {
            $currentParenthesis = $arrowElement
            continue # and keep moving if we find one.
        }

        # Do the same thing if we found a variable, unless it's `$_`.
        if ($arrowElement -is [Management.Automation.Language.VariableExpressionAST] -and
            '$_' -ne $arrowElement) {
            $currentVariable = $arrowElement
            continue
        }
        
        
        if ($arrowElement -is [Management.Automation.Language.StringConstantExpressionAst]) {
            # If we find another arrow element, skip
            if ($arrowElement.Value -eq '=>') {
                continue
            }
            # If the elements value was ? or ?=>            
            if ($arrowElement.Value -eq '?' -or 
                $arrowElement.Value -eq '?=>') {
                # treat it as a condition.
                $IsCondition = $true
                continue
            }

            # If we're generating a lambda
            if ($IsGeneratingALambda) {
                # a bareword will become the function name.
                $functionNames += $arrowElement.Value
            }
        }
            
        # Construct our parameter block (using our little script block)
        $paramBlock = . $ConvertParensAndVariablesExpressionToParameters

        $expr = # Make all expressions script like
            if ($arrowElement -is [Management.Automation.Language.ScriptBlockExpressionAst]) {
                "$arrowElement"
            } else {
                "{ $arrowElement}"
            }

        # If the current step is a condition
        if ($IsCondition) {
            # make the expression pass thru if the condition is true.
            $expr = "{ `$in = `$_; `$out = & $expr; if (`$out) { `$in } }"
        }
        

        # Set up the parameter block
        $paramBlock = 
            if ($paramBlock) {
                (
                    # (indentation and all)
                    " param(",
                    ((' ' * 8) + $paramBlock),
                    ((' ' * 8) + ')') -join 
                        [Environment]::NewLine
                ) + 
                    [Environment]::NewLine + 
                    (' ' * 8)
            } else {
                ' '
            }

        $ClosingBrace = # If we had a parameter block
            if ($paramBlock -eq ' ') {
                '}'
            } else {
                # drop the closing brace.
                [Environment]::NewLine + (' ' * 4) + '}'
            }
        
        # Add this step to the generated pipeline.
        # If the current element is a ScriptBlockExpression
        if ($arrowElement -is [Management.Automation.Language.ScriptBlockExpressionAst] -and 
            $(
                # and it has named blocks
                $arrowScriptAst = $arrowElement.ScriptBlock
                ($arrowScriptAst.ProcessBlock -or 
                $arrowScriptAst.ParamBlock -or 
                $arrowScriptAst.BeginBlock -or 
                $arrowScriptAst.CleanBlock -or
                ($arrowScriptAst.EndBlock -and -not $arrowScriptAst.EndBlock.Unnamed))
            )
        ) {
            # Then embed it directly
            $generatedPipeline += ". $arrowElement"
        } else {
            # Otherwise throw in the parameter block.
            $generatedPipeline += ". {${paramBlock}process $expr $ClosingBrace"
        }
        
        # If we were processing a condition
        if ($IsCondition) {
            # just flip that bit back and keep our paranethesis/variables.
            $IsCondition = $false
        } else {
            # Otherwise, reset our variables for the next one.
            $currentParenthesis = $null
            $currentVariable = $null
        }            
    }

    # If the arrow operator ends with a variable, consider it an assignment of the entire pipeline.
    $assignResultTo = $null
    if ($currentVariable) {
        $assignResultTo = $currentVariable
        $currentVariable = $null
    }
    
    # If the arrow operator ends with parenthesis, consider it something like a select
    if ($currentParenthesis) {
        $paramBlock = . $ConvertParensAndVariablesExpressionToParameters
    }

    # If we have current parenthesis or we're assigning, make sure our final step outputs.
    if ($currentParenthesis -or $assignResultTo) {
        $generatedPipeline += "& { $(if ($paramBlock) { "param($ParamBlock)" }) process { $(if ($paramBlock) { '[PSCustomObject]([Ordered]@{} + $PSBoundParameters)'} else { '$_'})} }"
    }


    $generatedScript =
        # If we're generating a lambda,
        if ($IsGeneratingALambda) {
            # always omit `func`
            $(if ($generatedPipeline[0] -notmatch '^func') {
                # and turn `$function` into the name of functions, if provided.
                if ($generatedPipeline[0] -match '^\$\{?function\}?' -and $functionNames) {
                    # (we can do this by using the function drive)
                    (@(foreach ($fn in $functionNames) {
                        "`${function:$fn}"
                    }) -join ' = ') + ' ='
                } else {
                    # (any path already in the function drive is handled normally)                    
                    ($GeneratedPipeline[0] + ' =')
                }                
            } else { '' }) + 
            [Environment]::NewLine +
            (
                # String together the rest of the pipeline
                $GeneratedPipeline[1..($generatedPipeline.Length - 1)] -join (
                    '|' + [Environment]::NewLine + (' ' * 4)
                ) -replace '^[\&\.]\s{0,}' # and strip our leading invocation operator
                # (because we want to return a [ScriptBlock], not run it)
            )
        } else {
            # If we're not generating a lambda, just join the pipeline parts together.
            $GeneratedPipeline -join (
                '|' + [Environment]::NewLine + (' ' * 4)
            )
        }
    # Join all of the parts to construct the script
    

    # If we're assigning results, the script gets a little more complex:
    if ($assignResultTo) {
        # If we're being piped to,
        if ($ArrowCommandAst -and $ArrowCommandAst.IsPipedTo) {
            # dot source, then collect inputs in a queue, then pipe to the generated script and assign the result.
            $generatedScript = ". { begin { `$q = [Collections.Queue]::new() } process { `$q.Enqueue(`$_) } end { $assignResultTo = `$q | $generatedScript }} "
        } else {
            # If we're not being piped to, just make this the result of the pipeline.
            $generatedScript = "$assignResultTo = $generatedScript"
        }        
    }

    # Output the generated script, and our arrow operator should work.
    # Pipe the generated output to Use-PipeScript to transpile any remaining syntax.
    [ScriptBlock]::Create($generatedScript) | 
        Use-PipeScript
}