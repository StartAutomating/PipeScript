Template.PipeScript.ExplicitOutput
----------------------------------

### Synopsis
Makes Output from a PowerShell function Explicit.

---

### Description

Makes a PowerShell function explicitly output.

All statements will be assigned to $null, unless they explicitly use Write-Output or echo.

If Write-Output or echo is used, the command will be replaced for more effecient output.

---

### Examples
> EXAMPLE 1

```PowerShell
Invoke-PipeScript {
    [explicit()]
    param()
    "This Will Not Output"
    Write-Output "This Will Output"
}
```
> EXAMPLE 2

```PowerShell
{
    [explicit]{
        1,2,3,4
        echo "Output"
    }
} | .>PipeScript
```

---

### Parameters
#### **ScriptBlock**
The ScriptBlock that will be transpiled.

|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[ScriptBlock]`|true    |1       |true (ByValue)|

---

### Outputs
* [Management.Automation.ScriptBlock](https://learn.microsoft.com/en-us/dotnet/api/System.Management.Automation.ScriptBlock)

---

### Syntax
```PowerShell
Template.PipeScript.ExplicitOutput [-ScriptBlock] <ScriptBlock> [<CommonParameters>]
```
