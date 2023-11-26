PipeScript.PostProcess.InitializeAutomaticVariables
---------------------------------------------------

### Synopsis
Initializes any automatic variables

---

### Description

Initializes any automatic variables at the beginning of a script block.

This enables Automatic?Variable* and Magic?Variable* commands to be populated and populated effeciently.

For example:
* If a function exists named Automatic.Variable.MyCallstack
* AND $myCallStack is used within a ScriptBlock

Then the body of Automatic.Variable.MyCallstack will be added to the top of the ScriptBlock.

---

### Examples
Declare an automatic variable, MyCallStack

```PowerShell
Import-PipeScript {
    Automatic.Variable function MyCallstack {
        Get-PSCallstack
    }
}
# Now we can use $MyCallstack as-is.
# It will be initialized at the beginning of the script
{
    $MyCallstack
} | Use-PipeScript
```

---

### Parameters
#### **ScriptBlock**

|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[ScriptBlock]`|true    |named   |true (ByValue)|

#### **FunctionDefinitionAst**

|Type                     |Required|Position|PipelineInput |
|-------------------------|--------|--------|--------------|
|`[FunctionDefinitionAst]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
PipeScript.PostProcess.InitializeAutomaticVariables -ScriptBlock <ScriptBlock> [<CommonParameters>]
```
```PowerShell
PipeScript.PostProcess.InitializeAutomaticVariables -FunctionDefinitionAst <FunctionDefinitionAst> [<CommonParameters>]
```
