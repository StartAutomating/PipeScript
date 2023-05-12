PipeScript.PostProcess.InitializeAutomaticVariables
---------------------------------------------------




### Synopsis
Initializes any automatic variables



---


### Description

Initializes any automatic variables at the beginning of a script block.
This enables Automatic?Variable* and Magic?Variable* commands to be populated and populated effeciently.



---


### Examples
#### EXAMPLE 1
```PowerShell
Import-PipeScript {
    Automatic.Variable. function MyCallstack {
        Get-PSCallstack
    }
}
{
    $MyCallstack
} | Use-PipeScript
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
PipeScript.PostProcess.InitializeAutomaticVariables [-ScriptBlock] <ScriptBlock> [<CommonParameters>]
```
