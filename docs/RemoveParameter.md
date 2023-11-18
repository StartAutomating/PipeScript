RemoveParameter
---------------

### Synopsis
Removes Parameters from a ScriptBlock

---

### Description

Removes Parameters from a ScriptBlock

---

### Related Links
* [Update-PipeScript](Update-PipeScript.md)

---

### Examples
> EXAMPLE 1

```PowerShell
{
    [RemoveParameter("x")]
    param($x, $y)
} | .>PipeScript
```

---

### Parameters
#### **ParameterName**
The name of one or more parameters to remove

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|true    |1       |false        |

#### **ScriptBlock**
The ScriptBlock that declares the parameters.

|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[ScriptBlock]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
RemoveParameter [-ParameterName] <String[]> -ScriptBlock <ScriptBlock> [<CommonParameters>]
```
