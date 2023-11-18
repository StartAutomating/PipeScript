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
> EXAMPLE 1

```PowerShell
Get-Command Join-PipeScript | Join-PipeScript
```
> EXAMPLE 2

```PowerShell
{param([string]$x)},
{param([string]$y)} | 
    Join-PipeScript # Should -BeLike '*param(*$x,*$y*)*'
```
> EXAMPLE 3

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
> EXAMPLE 4

```PowerShell
{
    param($x = 1)
} | Join-PipeScript -ExcludeParameter x
```

---

### Parameters
#### **ScriptBlock**
A ScriptBlock written in PowerShell or PipeScript.

|Type             |Required|Position|PipelineInput                 |Aliases   |
|-----------------|--------|--------|------------------------------|----------|
|`[ScriptBlock[]]`|true    |named   |true (ByValue, ByPropertyName)|Definition|

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

|Type        |Required|Position|PipelineInput|Aliases                                               |
|------------|--------|--------|-------------|------------------------------------------------------|
|`[String[]]`|false   |named   |false        |SkipBlockType<br/>SkipBlockTypes<br/>ExcludeBlockTypes|

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

|Type        |Required|Position|PipelineInput|Aliases                                       |
|------------|--------|--------|-------------|----------------------------------------------|
|`[String[]]`|false   |named   |false        |BlockType<br/>BlockTypes<br/>IncludeBlockTypes|

#### **Transpile**
If set, will transpile the joined ScriptBlock.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **IncludeParameter**
A list of parameters to include.  Can contain wildcards.
If -IncludeParameter is provided without -ExcludeParameter, all other parameters will be excluded.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |named   |false        |

#### **ExcludeParameter**
A list of parameters to exclude.  Can contain wildcards.
Excluded parameters with default values will declare the default value at the beginnning of the command.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |named   |false        |

#### **Indent**
The amount of indentation to use for parameters and named blocks.  By default, four spaces.

|Type     |Required|Position|PipelineInput|Aliases    |
|---------|--------|--------|-------------|-----------|
|`[Int32]`|false   |named   |false        |Indentation|

---

### Syntax
```PowerShell
Join-PipeScript -ScriptBlock <ScriptBlock[]> [-ExcludeBlockType <String[]>] [-IncludeBlockType <String[]>] [-Transpile] [-IncludeParameter <String[]>] [-ExcludeParameter <String[]>] [-Indent <Int32>] [<CommonParameters>]
```
