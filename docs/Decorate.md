Decorate
--------

### Synopsis
decorate transpiler

---

### Description

Applies one or more typenames to an object.
By 'decorating' the object with a typename, this enables use of the extended type system.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    $v = [PSCustomObject]@{}
    [decorate('MyTypeName',Clear,PassThru)]$v
}.Transpile()
```

---

### Parameters
#### **VariableAst**
The variable decoration will be applied to.

|Type                     |Required|Position|PipelineInput |
|-------------------------|--------|--------|--------------|
|`[VariableExpressionAst]`|true    |named   |true (ByValue)|

#### **TypeName**
The TypeName(s) used to decorate the object.

|Type        |Required|Position|PipelineInput|Aliases   |
|------------|--------|--------|-------------|----------|
|`[String[]]`|true    |1       |false        |PSTypeName|

#### **PassThru**
If set, will output the object after it has been decorated

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **Clear**
If set, will clear any underlying typenames.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

---

### Syntax
```PowerShell
Decorate -VariableAst <VariableExpressionAst> [-TypeName] <String[]> [-PassThru] [-Clear] [<CommonParameters>]
```
