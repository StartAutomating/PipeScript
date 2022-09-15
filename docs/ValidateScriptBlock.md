
ValidateScriptBlock
-------------------
### Synopsis
Validates Script Blocks

---
### Description

Validates Script Blocks for a number of common scenarios.

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    param(
    [ValidateScriptBlock(Safe)]
    [ScriptBlock]
    $ScriptBlock
    )
```
$ScriptBlock
} | .>PipeScript
#### EXAMPLE 2
```PowerShell
{
    param(
    [ValidateScriptBlock(NoBlock,NoParameters)]
    [ScriptBlock]
    $ScriptBlock
    )
```
$ScriptBlock
} | .>PipeScript
#### EXAMPLE 3
```PowerShell
{
    param(
    [ValidateScriptBlock(OnlyParameters)]
    [ScriptBlock]
    $ScriptBlock
    )
```
$ScriptBlock
} | .>PipeScript
---
### Parameters
#### **DataLanguage**

If set, will validate that ScriptBlock is "safe".
This will attempt to recreate the Script Block as a datalanguage block and execute it.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ParameterOnly**

If set, will ensure that the [ScriptBlock] only has parameters



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **NoBlock**

If set, will ensure that the [ScriptBlock] has no named blocks.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **NoParameter**

If set, will ensure that the [ScriptBlock] has no parameters.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **VariableAST**

A VariableExpression.  If provided, the Validation attributes will apply to this variable.



> **Type**: ```[VariableExpressionAst]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
ValidateScriptBlock [-DataLanguage] [-ParameterOnly] [-NoBlock] [-NoParameter] [&lt;CommonParameters&gt;]
```
```PowerShell
ValidateScriptBlock [-DataLanguage] [-ParameterOnly] [-NoBlock] [-NoParameter] -VariableAST &lt;VariableExpressionAst&gt; [&lt;CommonParameters&gt;]
```
---



