When
----

### Synopsis
On / When keyword

---

### Description

The On / When keyword makes it easier to subscribe to events in PowerShell and PipeScript

---

### Examples
> EXAMPLE 1

```PowerShell
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
```

---

### Parameters
#### **CommandAst**

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[CommandAst]`|true    |1       |true (ByValue)|

---

### Syntax
```PowerShell
When [-CommandAst] <CommandAst> [<CommonParameters>]
```
