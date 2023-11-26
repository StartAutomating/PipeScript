PipeScript.Optimizer.ConsolidateAspects
---------------------------------------

### Synopsis
Consolidates Code Aspects

---

### Description

Consolidates any ScriptBlockExpressions with the same content into variables.

---

### Examples
> EXAMPLE 1

```PowerShell
{        
    a.txt Template 'abc'
b.txt Template 'abc'
} | .>PipeScript
```
> EXAMPLE 2

```PowerShell
{
    aspect function SayHi {
        if (-not $args) { "Hello World"}
        else { $args }
    }
    function Greetings {
        SayHi
        SayHi "hallo Welt"
    }
} | .>PipeScript
```

---

### Parameters
#### **ScriptBlock**
The ScriptBlock.  All aspects used more than once within this ScriptBlock will be consolidated.

|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[ScriptBlock]`|true    |named   |true (ByValue)|

#### **FunctionDefinitionAst**
The Function Definition.  All aspects used more than once within this Function Definition will be consolidated.

|Type                     |Required|Position|PipelineInput |
|-------------------------|--------|--------|--------------|
|`[FunctionDefinitionAst]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
PipeScript.Optimizer.ConsolidateAspects -ScriptBlock <ScriptBlock> [<CommonParameters>]
```
```PowerShell
PipeScript.Optimizer.ConsolidateAspects -FunctionDefinitionAst <FunctionDefinitionAst> [<CommonParameters>]
```
