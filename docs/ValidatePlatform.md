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
#### EXAMPLE 1
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



> **Type**: ```[String[]]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:false



---
#### **VariableAST**

> **Type**: ```[VariableExpressionAst]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
ValidatePlatform [-Platform] <String[]> [<CommonParameters>]
```
```PowerShell
ValidatePlatform [-Platform] <String[]> [-VariableAST <VariableExpressionAst>] [<CommonParameters>]
```
---

