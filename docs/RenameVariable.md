RenameVariable
--------------

### Synopsis
Renames variables

---

### Description

Renames variables in a ScriptBlock

---

### Related Links
* [Update-PipeScript](Update-PipeScript.md)

---

### Examples
> EXAMPLE 1

```PowerShell
{
    [RenameVariable(VariableRename={
        @{
            x='x1'
            y='y1'
        }
    })]
    param($x, $y)
} | .>PipeScript
```

---

### Parameters
#### **VariableRename**
The name of one or more parameters to remove

|Type           |Required|Position|PipelineInput|Aliases                                                             |
|---------------|--------|--------|-------------|--------------------------------------------------------------------|
|`[IDictionary]`|true    |1       |false        |Variables<br/>RenameVariables<br/>RenameVariable<br/>VariableRenames|

#### **ScriptBlock**
The ScriptBlock that declares the parameters.

|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[ScriptBlock]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
RenameVariable [-VariableRename] <IDictionary> -ScriptBlock <ScriptBlock> [<CommonParameters>]
```
