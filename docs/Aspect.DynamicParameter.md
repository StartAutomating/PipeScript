Aspect.DynamicParameter
-----------------------

### Synopsis
Dynamic Parameter Aspect

---

### Description

The Dynamic Parameter Aspect is used to add dynamic parameters, well, dynamically.

It can create dynamic parameters from one or more input objects or scripts.

---

### Examples
> EXAMPLE 1

```PowerShell
Get-Command Get-Command | 
    Aspect.DynamicParameter
```
> EXAMPLE 2

```PowerShell
Get-Command Get-Process | 
    Aspect.DynamicParameter -IncludeParameter Name # Select -Expand Keys # Should -Be Name
```
> EXAMPLE 3

```PowerShell
Get-Command Get-Command, Get-Help | 
    Aspect.DynamicParameter
```

---

### Parameters
#### **InputObject**
The InputObject.
This can be anything, but will be ignored unless it is a `[ScriptBlock]` or `[Management.Automation.CommandInfo]`.

|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[PSObject]`|false   |1       |true (ByValue)|

#### **ParameterSetName**
The name of the parameter set the dynamic parameters will be placed into.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |2       |false        |

#### **PositionOffset**
The positional offset.  If this is provided, all positional parameters will be shifted by this number.
For example, if -PositionOffset is 1, the first parameter would become the second parameter (and so on)

|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |3       |false        |

#### **NoMandatory**
If set, will make all dynamic parameters non-mandatory.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **commandList**
If provided, will check that dynamic parameters are valid for a given command.
If the [Management.Automation.CmdletAttribute]

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |4       |false        |

#### **IncludeParameter**
If provided, will include only these parameters from the input.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |5       |false        |

#### **ExcludeParameter**
If provided, will exclude these parameters from the input.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |6       |false        |

#### **BlankParameter**
If provided, will make a blank parameter for every -PositionOffset.
This is so, presumably, whatever has already been provided in these positions will bind correctly.
The name of this parameter, by default, will be "ArgumentN" (for example, Argument1)

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **BlankParameterName**
The name of the blank parameter.
If there is a -PositionOffset, this will make a blank parameter by this name for the position.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |7       |false        |

---

### Syntax
```PowerShell
Aspect.DynamicParameter [[-InputObject] <PSObject>] [[-ParameterSetName] <String>] [[-PositionOffset] <Int32>] [-NoMandatory] [[-commandList] <String[]>] [[-IncludeParameter] <String[]>] [[-ExcludeParameter] <String[]>] [-BlankParameter] [[-BlankParameterName] <String[]>] [<CommonParameters>]
```
