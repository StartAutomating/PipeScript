using namespace System.Management.Automation.Language

<#
.SYNOPSIS
    Conditional Keyword Expansion
.DESCRIPTION
    Allows for conditional Keywords.

    A coniditional keyword is a continue or break statement, followed by a partial if clause.    
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
    if ($ast -isnot [ContinueStatementAst] -and 
        $ast -isnot [BreakStatementAst] -and
        $ast -isnot [ReturnStatementAst] -and
        $ast -isnot [ThrowStatementAst]
    ) {
        return $false
    }
    if (-not $ast.Pipeline) {
        $nextStatement = $ast.Parent.Statements[$ast.Parent.Statements.IndexOf($ast) + 1]
        if (-not $nextStatement) { 
            return $false
        }
    

        if ('if' -ne $ast.Label) {
            if ($nextStatement -is [IfStatementAst]) {
                return $true
            }
            return $false
        }

        return $true
    }
    else {
        return $ast.Pipeline -match '^if'
    }    
})]
param(
# A Continue Statement.
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='ContinueStatement')]
[ContinueStatementAst]
$ContinueStatement,

# A Break Statement.
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='BreakStatement')]
[BreakStatementAst]
$BreakStatement,

# A Return Statement.
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='ReturnStatement')]
[ReturnStatementAst]
$ReturnStatement,

# A Throw Statement.
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='ThrowStatement')]
[ThrowStatementAst]
$ThrowStatement
)

process {
    
    $statement = $($PSBoundParameters[$PSBoundParameters.Keys -like '*Statement'])
    if (-not $statement) { return }
    $statementType = ($statement.GetType().Name -replace 'StatementAst').ToLower()
    $PipelineClauses = @()
    $nextStatement = 
        if ($statement.Pipeline) {
            $firstElement = $statement.Pipeline.PipelineElements[0]
            $commandElements = $firstElement.CommandElements[1..($firstElement.CommandElements.Count)]
            foreach ($CommandElement in $commandElements) {
                if ($commandElement -is [ScriptBlockExpressionAst]) {
                    $PipelineClauses += $CommandElement.ScriptBlock.GetScriptBlock()
                } else {
                    $CommandElement
                }
            }
        } else {
            $statement.Parent.Statements[$statement.Parent.Statements.IndexOf($statement) + 1]
        }
        
    
    $(if ($nextStatement -is [IfStatementAst]) {
        [ScriptBlock]::Create("if ($($nextStatement.Clauses[0].Item1)) { 
            $(
                $ReplacedClause = $nextStatement.Clauses[0].Item2 -replace '^\s{0,}\{\s{0,}' -replace '\s{0,}\}\s{0,}$'
                if ($ReplacedClause) {
                    $ReplacedClause + ';' + "$statementType $($statement.Label)"
                } else {
                    "$statementType $($statement.Label)"
                }
            )                        
        }")
    } 
    elseif ($PipelineClauses) {        
        [ScriptBlock]::Create("if ($nextStatement) { $statementType $pipelineClauses}")
    }
    else {
        [ScriptBlock]::Create("if ($nextStatement) { $statementType }")
    })
        | Add-Member NoteProperty SkipUntil $nextStatement -PassThru    
}

