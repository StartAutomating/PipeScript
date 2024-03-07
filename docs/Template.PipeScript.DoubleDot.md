Template.PipeScript.DoubleDot
-----------------------------

### Synopsis
Supports "Double Dotted" location changes

---

### Description

This little compiler is here to help small syntax flubs and relative file traversal.

Any pair of dots will be read as "Push-Location up N directories"

`^` + Any pair of dots will be read as "Pop-Location n times"

---

### Examples
> EXAMPLE 1

```PowerShell
Invoke-PipeScript { .. }
```
> EXAMPLE 2

```PowerShell
Invoke-PipeScript { ^.. }
```

---

### Parameters
#### **CommandAst**
The command ast

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[CommandAst]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
Template.PipeScript.DoubleDot -CommandAst <CommandAst> [<CommonParameters>]
```
