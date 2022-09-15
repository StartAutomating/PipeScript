<#
.SYNOPSIS
    until keyword
.DESCRIPTION
    The until keyword simplifies event loops.

    until will always run at least once, and will run until a condition is true.
.NOTES
    until will become a ```do {} while ()``` statement in PowerShell.
.EXAMPLE
    {
        $x = 0
        until ($x == 10) {
            $x            
            $x++
        }        
    } |.>PipeScript
.EXAMPLE
    Invoke-PipeScript {
        until "00:00:05" {
            [DateTime]::Now
            Start-Sleep -Milliseconds 500
        } 
    }
.EXAMPLE
    Invoke-PipeScript {
        until "12:17 pm" {
            [DateTime]::Now
            Start-Sleep -Milliseconds 500
        } 
    }
.EXAMPLE
    {
        $eventCounter = 0
        until "MyEvent" {
            $eventCounter++
            $eventCounter
            until "00:00:03" {
                "sleeping a few seconds"
                Start-Sleep -Milliseconds 500
            }
            if (-not ($eventCounter % 5)) {
                $null = New-Event -SourceIdentifier MyEvent
            }
        }
    } | .>PipeScript
.EXAMPLE
    Invoke-PipeScript {
        $tries = 3
        until (-not $tries) {
            "$tries tries left"
            $tries--            
        }
    }
#>
[ValidateScript({
    $commandAst = $_    
    return ($commandAst -and 
        $CommandAst.CommandElements[0].Value -eq 'until' -or
        (
            $commandAst.CommandElements.Count -ge 2 -and 
            $commandAst.CommandElements[0].Value -like ':*' -and
            $commandAst.CommandElements[1].Value -eq 'until'
        )
    )
})]
param(
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='CommandAst')]
[Management.Automation.Language.CommandAst]
$CommandAst
)

begin {
    $myCmdName = $MyInvocation.MyCommand.Name
}

process {
    $CommandName, $CommandArgs = $commandAst.CommandElements
    if ($commandName -like ':*') {
        $null, $firstArg, $secondArg = $CommandAst.ArgumentList
    } else {
        $firstArg, $secondArg = $CommandAst.ArgumentList
    }
    

    # If the first arg is a command expression, it becomes do {} while ($firstArg)
    if (-not $firstArg -or $firstArg.GetType().Name -notin 
        'ParenExpressionAst', 'ScriptBlockExpressionAst',
        'VariableExpressionAst','MemberExpressionAst',
        'string',
        'ExpandableStringExpressionAst') {
        Write-Error "Until must be followed by a Variable, Member, ExpandableString, or Parenthesis Expression"
        return
    }

    if ($secondArg -isnot [Scriptblock]) {
        Write-Error "Until must be followed by a condition and a ScriptBlock"
        return
    }

    $condition = $firstArg
    if ($firstArg.GetType().Name -eq 'ParenExpressionAst' -and 
        $firstArg.Pipeline.PipelineElements.Count -eq 1 -and 
        $firstArg.Pipeline.PipelineElements[0].Expression -and 
        $firstArg.Pipeline.PipelineElements[0].Expression.GetType().Name -in 
        'VariableExpressionAst','MemberExpressionAst','ExpandableStringExpressionAst', 
        'StringConstantExpressionAst') {
        $condition = $firstArg.Pipeline.PipelineElements[0].Expression
    }
    elseif ($firstArg.GetType().Name -eq 'ScriptBlockExpressionAst') {
        $condition = $firstArg -replace '^\{' -replace '\}$'
    }

    $BeforeLoop      = ''
        
    $callstack       = Get-PSCallStack
    $callCount       = @($callstack | 
        Where-Object { $_.InvocationInfo.MyCommand.Name -eq $myCmdName}).count - 1
    $untilVar = '$' + ('_' * $callCount) + 'untilStartTime'

    if ($condition -is [string]) {
        
        
        if ($condition -as [Timespan]) {            
            $beforeLoop = "$untilVar = [DateTime]::Now"
            $condition  = "(([DateTime]::Now - $untilVar) -ge ([Timespan]'$Condition'))"
        }
        elseif ($condition -as [DateTime]) {
            $condition = "[DateTime]::Now -ge ([DateTime]'$Condition')"
        }
        else {
            $beforeLoop = "$untilVar = [DateTime]::Now"
            $condition  = 'Get-Event -SourceIdentifier ' + "'$condition'" + " -ErrorAction Ignore | Where-Object TimeGenerated -ge $untilVar" 
        }
    }
    
    $conditionScript = [ScriptBlock]::Create($condition)
    $LoopScript = $secondArg

    $secondArgScriptBlock = [ScriptBlock]::Create($LoopScript)
    
    $conditionScript = $conditionScript      | .>Pipescript
    $untilTranspiled = $secondArgScriptBlock | .>Pipescript
    
    $newScript = @"
$(if ($BeforeLoop) { $BeforeLoop + [Environment]::NewLine})
$(if ($CommandName -like ':*') { "$CommandName "})do {
$untilTranspiled
} until $conditionScript
"@
    
    [ScriptBlock]::Create($newScript)
}
