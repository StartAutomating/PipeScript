Help
----

### Synopsis
Help Transpiler

---

### Description

The Help Transpiler allows you to write inline help without directly writing comments.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    [Help(Synopsis="The Synopsis", Description="A Description")]
    param()
"This Script Has Help, Without Directly Writing Comments"
    
} | .>PipeScript
```
> EXAMPLE 2

```PowerShell
{
    param(
    [Help(Synopsis="X Value")]
    $x
    )
} | .>PipeScript
```
> EXAMPLE 3

```PowerShell
{
    param(
    [Help("X Value")]
    $x
    )
} | .>PipeScript
```

---

### Parameters
#### **Synopsis**
The synopsis of the help topic

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|true    |1       |false        |

#### **Description**
The description of the help topic

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **Example**
One or more examples

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |named   |false        |

#### **Link**
One or more links

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |named   |false        |

#### **ScriptBlock**
A ScriptBlock.  If this is provided, the help will be added to this scriptblock.

|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[ScriptBlock]`|false   |named   |true (ByValue)|

---

### Syntax
```PowerShell
Help [-Synopsis] <String> [-Description <String>] [-Example <String[]>] [-Link <String[]>] [<CommonParameters>]
```
```PowerShell
Help [-Synopsis] <String> [-Description <String>] [-Example <String[]>] [-Link <String[]>] [-ScriptBlock <ScriptBlock>] [<CommonParameters>]
```
