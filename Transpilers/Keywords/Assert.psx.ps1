<#
.SYNOPSIS
    Assert keyword
.DESCRIPTION
    Assert is a common keyword in many programming languages.
    
    In PipeScript, Asset will take a condition and an optional action.

    If the condition returns null, false, or empty, the assertion will be thrown.

    The condition may be contained in either parenthesis or a [ScriptBlock].

    If there is no action, the assertion will throw an exception containing the condition.

    If the action is a string, the assertion will throw that error as a string.

    If the action is a ScriptBlock, it will be run if the assertion is false.

    Assertions will not be transpiled or included if -Verbose or -Debug has not been set.

    Additionally, while running, Assertions will be ignored if -Verbose or -Debug has not been set.
.EXAMPLE
    # With no second argument, assert will throw an error with the condition of the assertion.
    Invoke-PipeScript {
        assert (1 -ne 1)
    } -Debug
.EXAMPLE
    # With a second argument of a string, assert will throw an error
    Invoke-PipeScript {
        assert ($false) "It's not true!"
    } -Debug
.EXAMPLE
    # Conditions can also be written as a ScriptBlock
    Invoke-PipeScript {
        assert {$false} "Process id '$pid' Asserted"
    } -Verbose
.EXAMPLE
    # If the assertion action was a ScriptBlock, no exception is automatically thrown
    Invoke-PipeScript {
        assert ($false) { Write-Information "I Assert There Is a Problem"}
    } -Verbose
.EXAMPLE
    # assert can be used with the object pipeline.  $_ will be the current object.
    Invoke-PipeScript {
        1..4 | assert {$_ % 2} "$_ is not odd!"
    } -Debug
.EXAMPLE
    # You can provide a ```[ScriptBlock]``` as the second argument to see each failure
    Invoke-PipeScript {
        1..4 | assert {$_ % 2} { Write-Error "$_ is not odd!" }
    } -Debug
#>
[ValidateScript({
    # This transpiler should run if the command is literally 'assert'
    $commandAst = $_
    if ($commandAst -isnot [Management.Automation.Language.CommandAst]) { return $false }
    return ($commandAst -and $CommandAst.CommandElements[0].Value -eq 'assert')
})]
param(
# The CommandAst
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='CommandAst')]
[Management.Automation.Language.CommandAst]
$CommandAst
)

process {
    $CommandName, $CommandArgs = $commandAst.CommandElements
    $firstArg, $secondArg = $CommandArgs

    # If the first arg can be a condition in simple or complex form
    if (-not $firstArg -or $firstArg.GetType().Name -notin 
        'ParenExpressionAst',
        'ScriptBlockExpressionAst',
        'VariableExpressionAst',
        'MemberExpressionAst',
        'StringConstantExpressionAst',
        'ExpandableStringExpressionAst') {
        # If it was the wrong type, let them know.
        Write-Error "Assert must be followed by one of the following expressions:
* Variable
* Member
* String
* Parenthesis
* ScriptBlock
"
        return
    }

    # If there was a second argument, it must be a string or ScriptBlock.
    if ($secondArg -and $secondArg.GetType().Name -notin 
        'ScriptBlockExpressionAst',
        'StringConstantExpressionAst',
        'ExpandableStringExpressionAst') {
        Write-Error "Assert must be followed by a ScriptBlock or string"
        return
    }

    # We need to create a [ScriptBlock] for the condition so we can transpile it.
    $firstArgTypeName = $firstArg.GetType().Name
    # The condition will always check for -DebugPreference or -VerbosePreference.
    $checkDebugPreference = '($debugPreference,$verbosePreference -ne ''silentlyContinue'')'

    $condition =
        [ScriptBlock]::Create("($checkDebugPreference -and -not $(
            # If the condition is already in parenthesis,
            if ($firstArgTypeName -eq 'ParenExpressionAst') {                
                "$FirstArg" # leave it alone.
            }
            # If the condition is a ScriptBlockExpression,
            elseif ($firstArgTypeName -eq 'ScriptBlockExpressionAst')
            {
                # put it in parenthesis.
                "($($FirstArg.AsScriptBlock()))"
            }
            # Otherwise
            else
            {
                "($FirstArg)" # embed the condition in parenthesis.
            }
        ))")

    # Transpile the condition.
    $condition = $condition | .>Pipescript
    
    # Now we create the entire assertion script
    $newScript = 
        # If there was no second argument
        if (-not $secondArg) {
            # Rethrow the condition
            "if $condition { throw '{$($firstArg -replace "'", "''")}' } "
        } elseif ($secondArg.GetType().Name -eq 'ScriptBlockExpressionAst') {
            # If the second argument was a script, transpile and embed it.
            "if $condition {$($secondArg.AsScriptBlock().Transpile())}"
        } else {
            # Otherwise, throw the second argument.
            "if $condition { throw $secondArg } "
        }
    
    
    $inPipeline = $false
    if ($CommandAst.Parent -is [Management.Automation.Language.PipelineAst] -and 
        $CommandAst.Parent.PipelineElements.Count -gt 1) {
        $inPipeline = $true
    }

    if ($DebugPreference, $VerbosePreference -ne 'silentlyContinue') {
        if ($inPipeline) {
            [scriptblock]::Create("& { process { $newScript } }")
        } else {
            [scriptblock]::Create($newScript)
        }
        
    } else {
        if ($inPipeline) {
            {& { process { $_ }}}
        } else {
            {}
        }
        
    }
}
