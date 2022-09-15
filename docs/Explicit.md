
Explicit
--------
### Synopsis
Makes Output from a PowerShell function Explicit.

---
### Description

Makes a PowerShell function explicitly output.

All statements will be assigned to $null, unless they explicitly use Write-Output or echo.

If Write-Output or echo is used, the command will be replaced for more effecient output.

---
### Examples
#### EXAMPLE 1
```PowerShell
Invoke-PipeScript {
    [explicit()]
    param()
    &quot;This Will Not Output&quot;
    Write-Output &quot;This Will Output&quot;
}
```

#### EXAMPLE 2
```PowerShell
{
    [explicit]{
        1,2,3,4
        echo &quot;Output&quot;
    }
} | .&gt;PipeScript
```

---
### Parameters
#### **ScriptBlock**

The ScriptBlock that will be transpiled.



> **Type**: ```[ScriptBlock]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByValue)



---
### Outputs
System.Management.Automation.ScriptBlock


---
### Syntax
```PowerShell
Explicit [-ScriptBlock] &lt;ScriptBlock&gt; [&lt;CommonParameters&gt;]
```
---



