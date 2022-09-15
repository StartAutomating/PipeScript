
Until
-----
### Synopsis
until keyword

---
### Description

The until keyword simplifies event loops.

until will always run at least once, and will run until a condition is true.

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    $x = 0
    until ($x == 10) {
        $x            
        $x++
    }        
} |.&gt;PipeScript
```

#### EXAMPLE 2
```PowerShell
Invoke-PipeScript {
    until &quot;00:00:05&quot; {
        [DateTime]::Now
        Start-Sleep -Milliseconds 500
    } 
}
```

#### EXAMPLE 3
```PowerShell
Invoke-PipeScript {
    until &quot;12:17 pm&quot; {
        [DateTime]::Now
        Start-Sleep -Milliseconds 500
    } 
}
```

#### EXAMPLE 4
```PowerShell
{
    $eventCounter = 0
    until &quot;MyEvent&quot; {
        $eventCounter++
        $eventCounter
        until &quot;00:00:03&quot; {
            &quot;sleeping a few seconds&quot;
            Start-Sleep -Milliseconds 500
        }
        if (-not ($eventCounter % 5)) {
            $null = New-Event -SourceIdentifier MyEvent
        }
    }
} | .&gt;PipeScript
```

#### EXAMPLE 5
```PowerShell
Invoke-PipeScript {
    $tries = 3
    until (-not $tries) {
        &quot;$tries tries left&quot;
        $tries--            
    }
}
```

---
### Parameters
#### **CommandAst**

> **Type**: ```[CommandAst]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
Until -CommandAst &lt;CommandAst&gt; [&lt;CommonParameters&gt;]
```
---
### Notes
until will become a ```do {} while ()``` statement in PowerShell.




