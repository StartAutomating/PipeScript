This directory and it's subdirectories contain additional language keywords within PipeScript.

Most keywords will be implemented as a Transpiler that tranforms a CommandAST.


|DisplayName             |Synopsis                        |
|------------------------|--------------------------------|
|[Assert](Assert.psx.ps1)|[Assert keyword](Assert.psx.ps1)|
|[New](New.psx.ps1)      |['new' keyword](New.psx.ps1)    |




## Assert Example 1


~~~PowerShell
    # With no second argument, assert will throw an error with the condition of the assertion.
    Invoke-PipeScript {
        assert (1 -eq 1)
    } -Debug
~~~

## Assert Example 2


~~~PowerShell
    # With a second argument of a string, assert will throw an error
    Invoke-PipeScript {
        assert ($true) "It's true"
    } -Debug
~~~

## Assert Example 3


~~~PowerShell
    # Conditions can also be written as a ScriptBlock
    Invoke-PipeScript {
        assert {$true} "Process id '$pid' Asserted"
    } -Verbose
~~~

## Assert Example 4


~~~PowerShell
    # If the assertion action was a ScriptBlock, no exception is automatically thrown
    Invoke-PipeScript {
        assert ($true) { Write-Information "Assertion was true"}
    } -Verbose
~~~

## New Example 1


~~~PowerShell
    .> { new DateTime }
~~~

## New Example 2


~~~PowerShell
    .> { new byte 1 }
~~~

## New Example 3


~~~PowerShell
    .> { new int[] 5 }
~~~

## New Example 4


~~~PowerShell
    .> { new Timespan }
~~~

## New Example 5


~~~PowerShell
    .> { new datetime 12/31/1999 }
~~~

## New Example 6


~~~PowerShell
    .> { new @{RandomNumber = Get-Random; A ='b'}}
~~~

## New Example 7


~~~PowerShell
    .> { new Diagnostics.ProcessStartInfo @{FileName='f'} }
~~~

