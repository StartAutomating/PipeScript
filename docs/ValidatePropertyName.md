ValidatePropertyName
--------------------

### Synopsis
Validates Property Names

---

### Description

Validates that an object has one or more property names.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    param(
    [ValidatePropertyName(PropertyName='a','b')]
    $InputObject
    )
} | .>PipeScript
```
> EXAMPLE 2

```PowerShell
[PSCustomObject]@{a='a';b='b'} |
    .> {
        param(
        [ValidatePropertyName(PropertyName='a','b')]
        [vfp]
        $InputObject
        )
$InputObject
    }
```
> EXAMPLE 3

```PowerShell
@{a='a'} |
    .> {
        param(
        [ValidatePropertyName(PropertyName='a','b')]
        [vfp]
        $InputObject
        )
$InputObject
    }
```

---

### Parameters
#### **PropertyName**
The property names being validated.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|true    |1       |false        |

#### **VariableAST**
A variable expression.
If this is provided, will apply a ```[ValidateScript({})]``` attribute to the variable, constraining future values.

|Type                     |Required|Position|PipelineInput |
|-------------------------|--------|--------|--------------|
|`[VariableExpressionAst]`|false   |named   |true (ByValue)|

---

### Syntax
```PowerShell
ValidatePropertyName [-PropertyName] <String[]> [<CommonParameters>]
```
```PowerShell
ValidatePropertyName [-PropertyName] <String[]> [-VariableAST <VariableExpressionAst>] [<CommonParameters>]
```
