Template.PipeScript.WhereMethod
-------------------------------

### Synopsis
Where Method

---

### Description

Where-Object cannot simply run a method with parameters on each object.

However, we can easily rewrite a Where-Object statement to do exactly that.

---

### Examples
> EXAMPLE 1

```PowerShell
{ Get-PipeScript | ? CouldPipeType([ScriptBlock]) } | Use-PipeScript
```

---

### Parameters
#### **WhereCommandAst**
The Where-Object Command AST.

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[CommandAst]`|true    |1       |true (ByValue)|

---

### Syntax
```PowerShell
Template.PipeScript.WhereMethod [-WhereCommandAst] <CommandAst> [<CommonParameters>]
```
