
Include
-------
### Synopsis
Includes Files

---
### Description

Includes Files or Functions into a Script.

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    [Include(&quot;Invoke-PipeScript&quot;)]$null
} | .&gt;PipeScript
```

#### EXAMPLE 2
```PowerShell
{
    [Include(&quot;Invoke-PipeScript&quot;)]
    param()
} | .&gt;PipeScript
```

#### EXAMPLE 3
```PowerShell
{
    [Include(&#39;*-*.ps1&#39;)]$psScriptRoot
} | .&gt;PipeScript
```

---
### Parameters
#### **FilePath**

The File Path to Include



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:false



---
#### **AsByte**

If set, will include the content as a byte array



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **VariableAst**

> **Type**: ```[VariableExpressionAst]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
Include [-FilePath] &lt;String&gt; [-AsByte] -VariableAst &lt;VariableExpressionAst&gt; [&lt;CommonParameters&gt;]
```
---



