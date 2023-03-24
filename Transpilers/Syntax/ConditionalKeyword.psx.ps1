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
        $ast -isnot [BreakStatementAst]
    ) {
        return $false
    }
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
})]
param(
# A Continue Statement.
[Parameter(ValueFromPipeline,ParameterSetName='ContinueStatement')]
[ContinueStatementAst]
$ContinueStatement,

# A Break Statement.
[Parameter(ValueFromPipeline,ParameterSetName='BreakStatement')]
[BreakStatementAst]
$BreakStatement
)

process {
    
    $statement = if ($ContinueStatement) { $ContinueStatement} elseif ($BreakStatement ) { $BreakStatement }
    if (-not $statement) { return }
    $statementType = ($statement.GetType().Name -replace 'StatementAst').ToLower()
    $nextStatement = $statement.Parent.Statements[$statement.Parent.Statements.IndexOf($statement) + 1]
    
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
    } else {
        [ScriptBlock]::Create("if ($nextStatement) { $statementType }")
    })
        | Add-Member NoteProperty SkipUntil $nextStatement -PassThru    
}

