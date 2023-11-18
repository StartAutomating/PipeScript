Define
------

### Synopsis
Defines a variable

---

### Description

Defines a variable using a value provided at build time.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    [Define(Value={Get-Random})]$RandomNumber
}.Transpile()
```
> EXAMPLE 2

```PowerShell
{
    [Define(Value={$global:ThisValueExistsAtBuildTime})]$MyVariable
}.Transpile()
```

---

### Parameters
#### **Value**
The value to define.
When this value is provided within an attribute as a ScriptBlock, the ScriptBlock will be run at build time.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[PSObject]`|true    |named   |false        |

#### **VariableAst**
The variable the definition will be applied to.

|Type                     |Required|Position|PipelineInput |
|-------------------------|--------|--------|--------------|
|`[VariableExpressionAst]`|true    |named   |true (ByValue)|

#### **VariableName**
The name of the variable.  If define is applied as an attribute of a variable, this does not need to be provided.

|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[String]`|false   |named   |false        |Name   |

---

### Syntax
```PowerShell
Define -Value <PSObject> -VariableAst <VariableExpressionAst> [-VariableName <String>] [<CommonParameters>]
```
