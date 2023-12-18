<#
.SYNOPSIS
    Conditional Keyword Expansion
.DESCRIPTION
    Allows for conditional Keywords.

    A coniditional keyword is a continue or break statement, followed by a partial if clause.
    
    The following keywords can be used conditionally:

    |Keyword  |Example            |
    |---------|-----------------  |
    |break    |`break if $true`   |
    |continue |`continue if $true`|
    |return   |`return if $true`  |
    |throw    |`throw if $true`   |
.EXAMPLE
    Invoke-PipeScript {
        $n = 1
        do {
            $n = $n * 2
            $n
            break if (-not ($n % 16))
        } while ($true)
    }
.EXAMPLE
    Import-PipeScript {
        
        function Get-Primes([ValidateRange(2,64kb)][int]$UpTo) {
            $KnownPrimes = new Collections.ArrayList @(2)
            $SieveOfEratosthenes = new Collections.Generic.Dictionary[uint32,bool]            
            $n = 2
            :nextNumber for (; $n++;) {             
                # Break if past our point of interest
                break if ($n -ge $upTo)
                # Skip if an even number
                continue if (-not ($n -band 1))
                # Check our sieve
                continue if $SieveOfEratosthenes.ContainsKey($n)
                # Determine half of the number
                $halfN = $n /2
                # If this is divisible by the known primes
                foreach ($k in $knownPrimes) {
                    continue nextNumber if (($n % $k) -eq 0) {}
                    break if ($k -ge $halfN)
                }                
                foreach ($k in $knownPrimes) {
                    $SieveOfEratosthenes[$n * $k] = $true                
                }
                $null = $knownPrimes.Add($n)
            }
            $knownPrimes -le $UpTo
        }
    }
#>
[ValidateScript({
    $ast = $_
    # If the AST is not a break, continue, return, or throw statement
    if ($ast -isnot [Management.Automation.Language.ContinueStatementAst] -and 
        $ast -isnot [Management.Automation.Language.BreakStatementAst] -and
        $ast -isnot [Management.Automation.Language.ReturnStatementAst] -and
        $ast -isnot [Management.Automation.Language.ThrowStatementAst]
    ) {
        return $false # it is not valid for this transpiler.
    }

    # If there is no pipeline
    if (-not $ast.Pipeline) {
        # find the next statement
        $nextStatement = $ast.Parent.Statements[$ast.Parent.Statements.IndexOf($ast) + 1]
        # (If there isn't one, it's invalid)
        if (-not $nextStatement) {  return $false }

        # If the label was 'if', it's valid.
        if ('if' -eq $ast.Label) { return $true }

        # If the label is not if, it could be an actual label        
        # If the next statement is an if Statement, we're good
        if ($nextStatement -is [Management.Automation.Language.IfStatementAst]) {
            return $true
        }
        # If it wasn't, it's valid
        return $false    
    }
    else {
        # If there is a pipeline, it must start with 'if'
        return $ast.Pipeline -match '^if'
    }    
})]
param(
# A Continue Statement.
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='ContinueStatement')]
[Management.Automation.Language.ContinueStatementAst]
$ContinueStatement,

# A Break Statement.
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='BreakStatement')]
[Management.Automation.Language.BreakStatementAst]
$BreakStatement,

# A Return Statement.
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='ReturnStatement')]
[Management.Automation.Language.ReturnStatementAst]
$ReturnStatement,

# A Throw Statement.
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='ThrowStatement')]
[Management.Automation.Language.ThrowStatementAst]
$ThrowStatement
)

process {
    # Get the statement that will be transformed    
    $statement = $($PSBoundParameters[$PSBoundParameters.Keys -like '*Statement'])
    # (and return if we do not find one)
    if (-not $statement) { return }

    # Force the statement to be lowercase
    $statementType = ($statement.GetType().Name -replace 'StatementAst').ToLower()
    
    # There are two types of conditional keywords:
    # Labeled statements (continue/break)
    # Pipelined statements (return/throw)
    # For labeled statements, we will need to skip until a point
    $skipUntil = $null
    # For pipelined statements, we need to collect and script expression clauses
    $PipelineClauses = @()

    $nextStatement = 
        # If we are dealing with a labeled statement
        if (-not $statement.Pipeline) {
            # we will always skip the next statement
            $skipUntil = $statement.Parent.Statements[$statement.Parent.Statements.IndexOf($statement) + 1]
            $skipUntil
        } else {
            # Otherwise, go thru all command elements in the pipeline
            $firstElement = $statement.Pipeline.PipelineElements[0]
            # (skipping the first)
            $commandElements = $firstElement.CommandElements[1..($firstElement.CommandElements.Count)]
            foreach ($CommandElement in $commandElements) {
                # any script block expression makes up the closing clause
                if ($commandElement -is [Management.Automation.Language.ScriptBlockExpressionAst]) {
                    $PipelineClauses += $CommandElement.ScriptBlock.AsScriptBlock()
                } else {
                    # and all other command elements make up the condition.
                    $CommandElement
                }
            }
        }
        
    
    $(if ($nextStatement -is [Management.Automation.Language.IfStatementAst]) {
        # If the next statement was an if, recreate it's first clause
        [ScriptBlock]::Create("if ($($nextStatement.Clauses[0].Item1)) { 
            $(
                $ReplacedClause = $nextStatement.Clauses[0].Item2 -replace '^\s{0,}\{\s{0,}' -replace '\s{0,}\}\s{0,}$'
                # If the clause was not empty,
                if ($ReplacedClause) {
                    # add continue or break to the label.
                    $ReplacedClause + ';' + "$statementType $($statement.Label)"
                } else {
                    # otherwise, continue or break to the label.
                    "$statementType $($statement.Label)"
                }
            )                        
        }")
    } 
    elseif ($PipelineClauses) {
        # If we had pipeline clauses, include them as is.
        [ScriptBlock]::Create("if ($nextStatement) { $statementType $pipelineClauses}")
    }
    else {
        # Otherwise, make a simple if statement.
        [ScriptBlock]::Create("if ($nextStatement) { $statementType }")
    })
        | Add-Member NoteProperty SkipUntil $skipUntil -PassThru
}

