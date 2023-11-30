# PipeScript Keywords

PipeScript contains several new language keywords that are not found in PowerShell.

This directory contains the implementations of PipeScript language keywords.

## Keyword List


|DisplayName                 |Synopsis                                                              |
|----------------------------|----------------------------------------------------------------------|
|[All](All.psx.ps1)          |[all keyword](All.psx.ps1)                                            |
|[Assert](Assert.psx.ps1)    |[Assert keyword](Assert.psx.ps1)                                      |
|[Await](Await.psx.ps1)      |[awaits asynchronous operations](Await.psx.ps1)                       |
|[New](New.psx.ps1)          |['new' keyword](New.psx.ps1)                                          |
|[Object](Object.psx.ps1)    |[Object Keyword](Object.psx.ps1)                                      |
|[Requires](Requires.psx.ps1)|[requires one or more modules, variables, or types.](Requires.psx.ps1)|
|[Until](Until.psx.ps1)      |[until keyword](Until.psx.ps1)                                        |
|[When](When.psx.ps1)        |[On / When keyword](When.psx.ps1)                                     |



# Examples

## All Example 1


~~~PowerShell
    & {
    $glitters = @{glitters=$true}
    all that glitters
    }.Transpile()
~~~

## All Example 2


~~~PowerShell
    function mallard([switch]$Quack) { $Quack }
    Get-Command mallard | Get-Member  | Select-Object -ExpandProperty TypeName -Unique
    all functions that quack are ducks
    Get-Command mallard | Get-Member  | Select-Object -ExpandProperty TypeName -Unique
~~~

## All Example 3


~~~PowerShell
    
    . {
        $numbers = 1..100
        $null = all $numbers where { ($_ % 2) -eq 1 } are odd
        $null = all $numbers where { ($_ % 2) -eq 0 } are even
    }.Transpile()

    @(
        . { all even $numbers }.Transpile()
    ).Length

    @(
        . { all odd $numbers }.Transpile()
    ).Length
~~~

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

## Await Example 1


~~~PowerShell
    .>PipeScript -ScriptBlock {
        await $Websocket.SendAsync($SendSegment, 'Binary', $true, [Threading.CancellationToken]::new($false))
    }
~~~

## Await Example 2


~~~PowerShell
    .>PipeScript -ScriptBlock {
        $receiveResult = await $Websocket.ReceiveAsync($receiveSegment, [Threading.CancellationToken]::new($false))
    }
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

## New Example 10


~~~PowerShell
    .> { new 'https://schema.org/Thing' }
~~~

## Object Example 1


~~~PowerShell
    Use-PipeScript { object { $x = 1; $y = 2 }}
~~~

## Object Example 2


~~~PowerShell
    Use-PipeScript { object @{ x = 1; y = 2 }}
~~~

## Object Example 3


~~~PowerShell
    Use-PipeScript { Object }
~~~

## Requires Example 1


~~~PowerShell
    requires latest pipescript  # will require the latest version of pipescript
~~~

## Requires Example 2


~~~PowerShell
    requires variable $pid $sid # will error, because there is no $sid
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
    Invoke-PipeScript {
        until "00:00:05" {
            [DateTime]::Now
            Start-Sleep -Milliseconds 500
        } 
    }
~~~

## Until Example 3


~~~PowerShell
    Invoke-PipeScript {
        until "12:17 pm" {
            [DateTime]::Now
            Start-Sleep -Milliseconds 500
        } 
    }
~~~

## Until Example 4


~~~PowerShell
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
~~~

## Until Example 5


~~~PowerShell
    Invoke-PipeScript {
        $tries = 3
        until (-not $tries) {
            "$tries tries left"
            $tries--            
        }
    }
~~~

## When Example 1


~~~PowerShell
    Use-PipeScript {
        $y = when x {
            "y"
        }
    }

    Use-PipeScript {
        $timer = new Timers.Timer 1000 @{AutoReset=$false}
        when $timer.Elapsed {
            "time's up"
        }
    }
~~~



Keywords will generally be implemented as a Transpiler that tranforms a CommandAST.

