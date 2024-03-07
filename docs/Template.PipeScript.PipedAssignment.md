Template.PipeScript.PipedAssignment
-----------------------------------

### Synopsis
Piped Assignment Transpiler

---

### Description

Enables Piped Assignment (```|=|```).

Piped Assignment allows for an expression to be reassigned based off of the pipeline input.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    $Collection |=| Where-Object Name -match $Pattern
} | .>PipeScript
# This will become:

$Collection = $Collection | Where-Object Name -match $pattern
```
> EXAMPLE 2

```PowerShell
{
    $Collection |=| Where-Object Name -match $pattern | Select-Object -ExpandProperty Name
} | .>PipeScript
# This will become

$Collection = $Collection |
        Where-Object Name -match $pattern |
        Select-Object -ExpandProperty Name
```

---

### Parameters
#### **PipelineAst**

|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[PipelineAst]`|true    |1       |true (ByValue)|

---

### Syntax
```PowerShell
Template.PipeScript.PipedAssignment [-PipelineAst] <PipelineAst> [<CommonParameters>]
```
