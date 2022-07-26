This directory and it's subdirectories contain additional language keywords within PipeScript.

Most keywords will be implemented as a Transpiler that tranforms a CommandAST.


|DisplayName             |Synopsis                        |
|------------------------|--------------------------------|
|[Assert](Assert.psx.ps1)|[Assert keyword](Assert.psx.ps1)|
|[New](New.psx.ps1)      |['new' keyword](New.psx.ps1)    |
|[Until](Until.psx.ps1)  |[until keyword](Until.psx.ps1)  |




## Assert Example 1


~~~PowerShell
    # With no second argument, assert will throw an error with the condition of the assertion.
    Invoke-PipeScript {
        assert (1 -ne 1)
    } -Debug
~~~

## Assert Example 2


~~~PowerShell
    # With a second argument of a string, assert will throw an error
    Invoke-PipeScript {
        assert ($false) "It's not true!"
    } -Debug
~~~

## Assert Example 3


~~~PowerShell
    # Conditions can also be written as a ScriptBlock
    Invoke-PipeScript {
        assert {$false} "Process id '$pid' Asserted"
    } -Verbose
~~~

## Assert Example 4


~~~PowerShell
    # If the assertion action was a ScriptBlock, no exception is automatically thrown
    Invoke-PipeScript {
        assert ($false) { Write-Information "I Assert There Is a Problem"}
    } -Verbose
~~~

## Assert Example 5


~~~PowerShell
    # assert can be used with the object pipeline.  $_ will be the current object.
    Invoke-PipeScript {
        1..4 | assert {$_ % 2} "$_ is not odd!"
    } -Debug
~~~

## Assert Example 6


~~~PowerShell
    # You can provide a ```[ScriptBlock]``` as the second argument to see each failure
    Invoke-PipeScript {
        1..4 | assert {$_ % 2} { Write-Error "$_ is not odd!" }
    } -Debug
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

## New Example 8


~~~PowerShell
    .> { new ScriptBlock 'Get-Command'}
~~~

## New Example 9


~~~PowerShell
    .> { (new PowerShell).AddScript("Get-Command").Invoke() }
~~~

## Until Example 1


~~~PowerShell
    {
        $x = 0
        until ($x == 10) {
            $x            
            $x++
        }        
    } |.>PipeScript
~~~

## Until Example 2


~~~PowerShell
    {
        until "00:00:05" {
            [DateTime]::Now
            Start-Sleep -Milliseconds 500
        } 
    } | .>PipeScript
~~~

## Until Example 3


~~~PowerShell
    Invoke-PipeScript {
        $tries = 3
        until (-not $tries) {
            "$tries tries left"
            $tries--            
        }
    }
~~~

