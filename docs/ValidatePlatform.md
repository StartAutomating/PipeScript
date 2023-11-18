ValidatePlatform
----------------

### Synopsis
Validates the Platform

---

### Description

Validates the Platform.

When used within Parameters, this adds a ```[ValidateScript({})]``` to ensure that the platform is correct.

When used on a ```[Management.Automation.Language.VariableExpressionAst]``` will apply a 
```[ValidateScript({})]``` to that variable, which will prevent assignemnt to the variable if not on the platform.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    param(
    [ValidatePlatform("Windows")]
    [switch]
    $UseWMI
    )
} | .>PipeScript
```

---

### Parameters
#### **Platform**
The name of one or more platforms.  These will be interpreted as wildcards.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|true    |1       |false        |

#### **VariableAST**

|Type                     |Required|Position|PipelineInput |
|-------------------------|--------|--------|--------------|
|`[VariableExpressionAst]`|false   |named   |true (ByValue)|

---

### Syntax
```PowerShell
ValidatePlatform [-Platform] <String[]> [<CommonParameters>]
```
```PowerShell
ValidatePlatform [-Platform] <String[]> [-VariableAST <VariableExpressionAst>] [<CommonParameters>]
```
