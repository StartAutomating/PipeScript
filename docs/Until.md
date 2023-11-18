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
> EXAMPLE 1

```PowerShell
{
    $x = 0
    until ($x == 10) {
        $x            
        $x++
    }        
} |.>PipeScript
```
> EXAMPLE 2

```PowerShell
Invoke-PipeScript {
    until "00:00:05" {
        [DateTime]::Now
        Start-Sleep -Milliseconds 500
    } 
}
```
> EXAMPLE 3

```PowerShell
Invoke-PipeScript {
    until "12:17 pm" {
        [DateTime]::Now
        Start-Sleep -Milliseconds 500
    } 
}
```
> EXAMPLE 4

```PowerShell
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
```
> EXAMPLE 5

```PowerShell
Invoke-PipeScript {
    $tries = 3
    until (-not $tries) {
        "$tries tries left"
        $tries--            
    }
}
```

---

### Parameters
#### **CommandAst**

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[CommandAst]`|true    |named   |true (ByValue)|

---

### Notes
until will become a ```do {} while ()``` statement in PowerShell.

---

### Syntax
```PowerShell
Until -CommandAst <CommandAst> [<CommonParameters>]
```
