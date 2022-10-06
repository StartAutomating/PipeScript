
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
{param([string]$x)},
{param([string]$y)} | 
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

#### EXAMPLE 4
```PowerShell
{
    param($x = 1)
} | Join-PipeScript -ExcludeParameter x
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
#### **ExcludeBlockType**

A list of block types to be excluded during a merge of script blocks.
By default, no blocks will be excluded.



Valid Values:

* using
* requires
* help
* header
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
#### **IncludeBlockType**

A list of block types to include during a merge of script blocks.



Valid Values:

* using
* requires
* help
* header
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
#### **IncludeParameter**

A list of parameters to include.  Can contain wildcards.
If -IncludeParameter is provided without -ExcludeParameter, all other parameters will be excluded.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ExcludeParameter**

A list of parameters to exclude.  Can contain wildcards.
Excluded parameters with default values will declare the default value at the beginnning of the command.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
Join-PipeScript -ScriptBlock <ScriptBlock[]> [-ExcludeBlockType <String[]>] [-IncludeBlockType <String[]>] [-Transpile] [-IncludeParameter <String[]>] [-ExcludeParameter <String[]>] [<CommonParameters>]
```
---


