
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
} |.>PipeScript
```

#### EXAMPLE 2
```PowerShell
{
    until "00:00:05" {
        [DateTime]::Now
        Start-Sleep -Milliseconds 500
    } 
} | .>PipeScript
```

#### EXAMPLE 3
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

|Type              |Requried|Postion|PipelineInput |
|------------------|--------|-------|--------------|
|```[CommandAst]```|true    |named  |true (ByValue)|
---
### Syntax
```PowerShell
Until -CommandAst <CommandAst> [<CommonParameters>]
```
---
### Notes
until will become a ```do {} while ()``` statement in PowerShell.



