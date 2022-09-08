
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
#### EXAMPLE 1
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



|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[IDictionary]```|true    |1      |false        |
---
#### **ScriptBlock**

The ScriptBlock that declares the parameters.



|Type               |Requried|Postion|PipelineInput |
|-------------------|--------|-------|--------------|
|```[ScriptBlock]```|true    |named  |true (ByValue)|
---
### Syntax
```PowerShell
RenameVariable [-VariableRename] <IDictionary> -ScriptBlock <ScriptBlock> [<CommonParameters>]
```
---



