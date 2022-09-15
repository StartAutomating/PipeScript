
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
#### EXAMPLE 1
```PowerShell
{
    [RemoveParameter(&quot;x&quot;)]
    param($x, $y)
} | .&gt;PipeScript
```

---
### Parameters
#### **ParameterName**

The name of one or more parameters to remove



> **Type**: ```[String[]]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:false



---
#### **ScriptBlock**

The ScriptBlock that declares the parameters.



> **Type**: ```[ScriptBlock]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
RemoveParameter [-ParameterName] &lt;String[]&gt; -ScriptBlock &lt;ScriptBlock&gt; [&lt;CommonParameters&gt;]
```
---



