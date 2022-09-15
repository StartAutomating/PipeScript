
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
            x=&#39;x1&#39;
            y=&#39;y1&#39;
        }
    })]
    param($x, $y)
} | .&gt;PipeScript
```

---
### Parameters
#### **VariableRename**

The name of one or more parameters to remove



> **Type**: ```[IDictionary]```

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
RenameVariable [-VariableRename] &lt;IDictionary&gt; -ScriptBlock &lt;ScriptBlock&gt; [&lt;CommonParameters&gt;]
```
---



