ValidValues
-----------

### Synopsis
Dynamically Defines ValidateSet attributes

---

### Description

Can Dynamically Define ValidateSet attributes.

This is useful in circumstances where the valid set of values would be known at build, but would be tedious to write by hand.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    param(
    [ValidValues(Values={
       ([char]'a'..[char]'z')
    })]
    [string]
    $Drive
    )
} | .>PipeScript
```

---

### Parameters
#### **Values**
A list of valid values.
To provide a dynamic list, provide a `[ScriptBlock]` value in the attribute.

|Type        |Required|Position|PipelineInput|Aliases                             |
|------------|--------|--------|-------------|------------------------------------|
|`[String[]]`|true    |named   |false        |Value<br/>ValidValue<br/>ValidValues|

#### **Prefix**
If provided, will prefix each value

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **Suffix**
If provided, will add a suffix to each value

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **VariableAST**
A VariableExpression.  
If provided, this will be treated as the alias name or list of alias names.

|Type                     |Required|Position|PipelineInput |
|-------------------------|--------|--------|--------------|
|`[VariableExpressionAst]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
ValidValues -Values <String[]> [-Prefix <String>] [-Suffix <String>] [<CommonParameters>]
```
```PowerShell
ValidValues [-Prefix <String>] [-Suffix <String>] -VariableAST <VariableExpressionAst> [<CommonParameters>]
```
