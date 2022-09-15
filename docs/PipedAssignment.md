
PipedAssignment
---------------
### Synopsis
Piped Assignment Transpiler

---
### Description

Enables Piped Assignment (```|=|```).

Piped Assignment allows for an expression to be reassigned based off of the pipeline input.

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    $Collection |=| Where-Object Name -match $Pattern
} | .&gt;PipeScript
```
# This will become:

$Collection = $Collection | Where-Object Name -match $pattern
#### EXAMPLE 2
```PowerShell
{
    $Collection |=| Where-Object Name -match $pattern | Select-Object -ExpandProperty Name
} | .&gt;PipeScript
```
# This will become

$Collection = $Collection |
        Where-Object Name -match $pattern |
        Select-Object -ExpandProperty Name
---
### Parameters
#### **PipelineAst**

> **Type**: ```[PipelineAst]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
PipedAssignment [-PipelineAst] &lt;PipelineAst&gt; [&lt;CommonParameters&gt;]
```
---



