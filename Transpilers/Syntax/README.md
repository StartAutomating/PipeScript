This directory and it's subdirectories contain syntax changes that enable common programming scenarios in PowerShell and PipeScript.


|DisplayName                                             |Synopsis                                                          |
|--------------------------------------------------------|------------------------------------------------------------------|
|[NamespacedAlias](NamespacedAlias.psx.ps1)              |[Declares a namespaced alias](NamespacedAlias.psx.ps1)            |
|[NamespacedFunction](NamespacedFunction.psx.ps1)        |[Namespaced functions](NamespacedFunction.psx.ps1)                |
|[NamespacedObject](NamespacedObject.psx.ps1)            |[Namespaced functions](NamespacedObject.psx.ps1)                  |
|[ArrowOperator](ArrowOperator.psx.ps1)                  |[Arrow Operator](ArrowOperator.psx.ps1)                           |
|[ConditionalKeyword](ConditionalKeyword.psx.ps1)        |[Conditional Keyword Expansion](ConditionalKeyword.psx.ps1)       |
|[Dot](Dot.psx.ps1)                                      |[Dot Notation](Dot.psx.ps1)                                       |
|[DoubleDotting](DoubleDotting.psx.ps1)                  |[Supports "Double Dotted" location changes](DoubleDotting.psx.ps1)|
|[EqualityComparison](EqualityComparison.psx.ps1)        |[Allows equality comparison.](EqualityComparison.psx.ps1)         |
|[EqualityTypeComparison](EqualityTypeComparison.psx.ps1)|[Allows equality type comparison.](EqualityTypeComparison.psx.ps1)|
|[PipedAssignment](PipedAssignment.psx.ps1)              |[Piped Assignment Transpiler](PipedAssignment.psx.ps1)            |
|[SwitchAsIs](SwitchAsIs.psx.ps1)                        |[Switches based off of type, using as or is](SwitchAsIs.psx.ps1)  |
|[WhereMethod](WhereMethod.psx.ps1)                      |[Where Method](WhereMethod.psx.ps1)                               |




## NamespacedAlias Example 1


~~~PowerShell
    . {
        PipeScript.Template alias .\Transpilers\Templates\*.psx.ps1
    }.Transpile()
~~~

## NamespacedFunction Example 1


~~~PowerShell
    {
        abstract function Point {
            param(
            [Alias('Left')]
            [vbn()]
            $X,

            [Alias('Top')]
            [vbn()]
            $Y
            )
        }
    }.Transpile()
~~~

## NamespacedFunction Example 2


~~~PowerShell
    {
        interface function AccessToken {
            param(
            [Parameter(ValueFromPipelineByPropertyName)]
            [Alias('Bearer','PersonalAccessToken', 'PAT')]
            [string]
            $AccessToken
            )
        }
    }.Transpile()
~~~

## NamespacedFunction Example 3


~~~PowerShell
    {
        partial function PartialExample {
            process {
                1
            }
        }

        partial function PartialExample* {
            process {
                2
            }
        }

        partial function PartialExample// {
            process {
                3
            }
        }        

        function PartialExample {
            
        }
    }.Transpile()
~~~

## NamespacedObject Example 1


~~~PowerShell
    Invoke-PipeScript {
        My Object Precious { $IsARing = $true; $BindsThemAll = $true }
        My.Precious
    }
~~~

## ArrowOperator Example 1


~~~PowerShell
    $allTypes = 
        Invoke-PipeScript {
            [AppDomain]::CurrentDomain.GetAssemblies() => $_.GetTypes()
        }

    $allTypes.Count # Should -BeGreaterThan 1kb
    $allTypes # Should -BeOfType ([Type])
~~~

## ArrowOperator Example 2


~~~PowerShell
    Invoke-PipeScript {
        Get-Process -ID $PID => ($Name, $Id, $StartTime) => { "$Name [$ID] $StartTime"}
    } # Should -Match "$pid"
~~~

## ArrowOperator Example 3


~~~PowerShell
    Invoke-PipeScript {
        func => ($Name, $Id) { $Name, $Id}
    } # Should -BeOfType ([ScriptBlock])
~~~

## ConditionalKeyword Example 1


~~~PowerShell
    Invoke-PipeScript {
        $n = 1
        do {
            $n = $n * 2
            $n
            break if (-not ($n % 16))
        } while ($true)
    }
~~~

## ConditionalKeyword Example 2


~~~PowerShell
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
~~~

## Dot Example 1


~~~PowerShell
    .> {
        [DateTime]::now | .Month .Day .Year
    }
~~~

## Dot Example 2


~~~PowerShell
    .> {
        "abc", "123", "abc123" | .Length
    }
~~~

## Dot Example 3


~~~PowerShell
    .> { 1.99 | .ToString 'C' [CultureInfo]'gb-gb' }
~~~

## Dot Example 4


~~~PowerShell
    .> { 1.99 | .ToString('C') }
~~~

## Dot Example 5


~~~PowerShell
    .> { 1..5 | .Number { $_ } .Even { -not ($_ % 2) } .Odd { ($_ % 2) -as [bool]} }
~~~

## Dot Example 6


~~~PowerShell
    .> { .ID { Get-Random } .Count { 0 } .Total { 10 }}
~~~

## Dot Example 7


~~~PowerShell
    .> {
        # Declare a new object
        .Property = "ConstantValue" .Numbers = 1..100 .Double = {
            param($n)
            $n * 2
        } .EvenNumbers = {
            $this.Numbers | Where-Object { -not ($_ % 2)}
        } .OddNumbers = {
            $this.Numbers | Where-Object { $_ % 2}
        }
    }
~~~

## DoubleDotting Example 1


~~~PowerShell
    Invoke-PipeScript { .. }
~~~

## DoubleDotting Example 2


~~~PowerShell
    Invoke-PipeScript { ^.. }
~~~

## EqualityComparison Example 1


~~~PowerShell
    Invoke-PipeScript -ScriptBlock {
        $a = 1    
        if ($a == 1 ) {
            "A is $a"
        }
    }
~~~

## EqualityComparison Example 2


~~~PowerShell
    {
        $a == "b"
    } | .>PipeScript
~~~

## EqualityTypeComparison Example 1


~~~PowerShell
    Invoke-PipeScript -ScriptBlock {
        $a = 1
        $number = 1    
        if ($a === $number ) {
            "A is $a"
        }
    }
~~~

## EqualityTypeComparison Example 2


~~~PowerShell
    Invoke-PipeScript -ScriptBlock {
        $One = 1
        $OneIsNotANumber = "1"
        if ($one == $OneIsNotANumber) {
            'With ==, a number can be compared to a string, so $a == "1"'
        }
        if (-not ($One === $OneIsNotANumber)) {
            "With ===, a number isn't the same type as a string, so this will be false."            
        }
    }
~~~

## EqualityTypeComparison Example 3


~~~PowerShell
    Invoke-PipeScript -ScriptBlock {
        if ($null === $null) {
            '$Null really is $null'
        }
    }
~~~

## EqualityTypeComparison Example 4


~~~PowerShell
    Invoke-PipeScript -ScriptBlock {
        $zero = 0
        if (-not ($zero === $null)) {
            '$zero is not $null'
        }
    }
~~~

## EqualityTypeComparison Example 5


~~~PowerShell
    {
        $a = "b"
        $a === "b"
    } | .>PipeScript
~~~

## PipedAssignment Example 1


~~~PowerShell
    {
        $Collection |=| Where-Object Name -match $Pattern
    } | .>PipeScript

    # This will become:

    $Collection = $Collection | Where-Object Name -match $pattern
~~~

## PipedAssignment Example 2


~~~PowerShell
    {
        $Collection |=| Where-Object Name -match $pattern | Select-Object -ExpandProperty Name
    } | .>PipeScript

    # This will become

    $Collection = $Collection |
            Where-Object Name -match $pattern |
            Select-Object -ExpandProperty Name
~~~

## WhereMethod Example 1


~~~PowerShell
    { Get-PipeScript | ? CouldPipeType([ScriptBlock]) } | Use-PipeScript
~~~

