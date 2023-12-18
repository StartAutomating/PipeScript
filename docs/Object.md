Object
------

### Synopsis
Object Keyword

---

### Description

The Object Keyword helps you create objects or get the .NET type, `object`.

---

### Examples
> EXAMPLE 1

```PowerShell
Use-PipeScript { object { $x = 1; $y = 2 }}
```
> EXAMPLE 2

```PowerShell
Use-PipeScript { object @{ x = 1; y = 2 }}
```
> EXAMPLE 3

```PowerShell
Use-PipeScript { Object }
```

---

### Parameters
#### **ObjectCommandAst**
The Command Ast for the Object Keyword

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[CommandAst]`|false   |1       |true (ByValue)|

---

### Syntax
```PowerShell
Object [[-ObjectCommandAst] <CommandAst>] [<CommonParameters>]
```
