PipeScript.Optimizer.ConsolidateAspects
---------------------------------------




### Synopsis
Consolidates Code Aspects



---


### Description

Consolidates any ScriptBlockExpressions with the same content into variables.



---


### Examples
#### EXAMPLE 1
```PowerShell
{        
    a.txt Template 'abc'
    b.txt Template 'abc'
} | .>PipeScript
```

#### EXAMPLE 2
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




|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[ScriptBlock]`|true    |1       |true (ByValue)|





---


### Syntax
```PowerShell
PipeScript.Optimizer.ConsolidateAspects [-ScriptBlock] <ScriptBlock> [<CommonParameters>]
```
