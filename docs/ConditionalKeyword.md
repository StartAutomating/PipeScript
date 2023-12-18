ConditionalKeyword
------------------

### Synopsis
Conditional Keyword Expansion

---

### Description

Allows for conditional Keywords.

A coniditional keyword is a continue or break statement, followed by a partial if clause.

The following keywords can be used conditionally:

|Keyword  |Example            |
|---------|-----------------  |
|break    |`break if $true`   |
|continue |`continue if $true`|
|return   |`return if $true`  |
|throw    |`throw if $true`   |

---

### Examples
> EXAMPLE 1

```PowerShell
Invoke-PipeScript {
    $n = 1
    do {
        $n = $n * 2
        $n
        break if (-not ($n % 16))
    } while ($true)
}
```
> EXAMPLE 2

```PowerShell
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
```

---

### Parameters
#### **ContinueStatement**
A Continue Statement.

|Type                    |Required|Position|PipelineInput |
|------------------------|--------|--------|--------------|
|`[ContinueStatementAst]`|true    |named   |true (ByValue)|

#### **BreakStatement**
A Break Statement.

|Type                 |Required|Position|PipelineInput |
|---------------------|--------|--------|--------------|
|`[BreakStatementAst]`|true    |named   |true (ByValue)|

#### **ReturnStatement**
A Return Statement.

|Type                  |Required|Position|PipelineInput |
|----------------------|--------|--------|--------------|
|`[ReturnStatementAst]`|true    |named   |true (ByValue)|

#### **ThrowStatement**
A Throw Statement.

|Type                 |Required|Position|PipelineInput |
|---------------------|--------|--------|--------------|
|`[ThrowStatementAst]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
ConditionalKeyword -ContinueStatement <ContinueStatementAst> [<CommonParameters>]
```
```PowerShell
ConditionalKeyword -BreakStatement <BreakStatementAst> [<CommonParameters>]
```
```PowerShell
ConditionalKeyword -ReturnStatement <ReturnStatementAst> [<CommonParameters>]
```
```PowerShell
ConditionalKeyword -ThrowStatement <ThrowStatementAst> [<CommonParameters>]
```
