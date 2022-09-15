
Join-PipeScript
---------------
### Synopsis
Joins PowerShell and PipeScript ScriptBlocks

---
### Description

Joins ScriptBlocks written in PowerShell or PipeScript.

---
### Related Links
* [Update-PipeScript](Update-PipeScript.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-Command Join-PipeScript | Join-PipeScript
```

#### EXAMPLE 2
```PowerShell
{
param(
[string]
$x
)
},
{
param(            
[string]
$y
)
} | 
    Join-PipeScript
```

#### EXAMPLE 3
```PowerShell
{
    begin {
        $factor = 2
    }
}, {
    process {
        $_ * $factor
    }
} | Join-PipeScript
```

---
### Parameters
#### **ScriptBlock**

A ScriptBlock written in PowerShell or PipeScript.



> **Type**: ```[ScriptBlock[]]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue, ByPropertyName)



---
#### **SkipBlockType**

A list of block types to be skipped during a merge of script blocks.
By default, no blocks will be skipped



Valid Values:

* using
* requires
* help
* param
* dynamicParam
* begin
* process
* end



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **BlockType**

A list of block types to include during a merge of script blocks.



Valid Values:

* using
* requires
* help
* param
* dynamicParam
* begin
* process
* end



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Transpile**

If set, will transpile the joined ScriptBlock.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
Join-PipeScript -ScriptBlock &lt;ScriptBlock[]&gt; [-SkipBlockType &lt;String[]&gt;] [-BlockType &lt;String[]&gt;] [-Transpile] [&lt;CommonParameters&gt;]
```
---


