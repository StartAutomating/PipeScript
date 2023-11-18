Aliases
-------

### Synopsis
Dynamically Defines Aliases

---

### Description

Can Dynamically Define Aliases.

When uses in a parameter attribute, -Aliases will define a list of aliases.

When used with a variable, [Aliases] will Set-Alias on each value in the variable.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    $aliases = "Foo", "Bar", "Baz"
    [Aliases(Command="Get-Process")]$aliases
} | .>PipeScript
```
> EXAMPLE 2

```PowerShell
{
    param(
    [Aliases(Aliases={
       ([char]'a'..[char]'z')
    })]
    [string]
    $Drive
    )
} | .>PipeScript
```

---

### Parameters
#### **Aliases**
A list of aliases

|Type        |Required|Position|PipelineInput|Aliases|
|------------|--------|--------|-------------|-------|
|`[String[]]`|true    |named   |false        |Alias  |

#### **Prefix**
If provided, will prefix each alias

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **Suffix**
If provided, will add a suffix to each alias

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **Command**
The command being aliased.  This is only required when transpiling a variable.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|true    |named   |false        |

#### **PassThru**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **VariableAST**
A VariableExpression.  
If provided, this will be treated as the alias name or list of alias names.

|Type                     |Required|Position|PipelineInput |
|-------------------------|--------|--------|--------------|
|`[VariableExpressionAst]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
Aliases -Aliases <String[]> [-Prefix <String>] [-Suffix <String>] [<CommonParameters>]
```
```PowerShell
Aliases [-Prefix <String>] [-Suffix <String>] -Command <String> [-PassThru] -VariableAST <VariableExpressionAst> [<CommonParameters>]
```
