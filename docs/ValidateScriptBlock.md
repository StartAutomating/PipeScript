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
#### **IncludeCommand**

> **Type**: ```[Object]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ExcludeCommand**

> **Type**: ```[Object]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **IncludeType**

If set, will ensure that the script block contains types in this list.
Passing -IncludeType without -ExcludeType will make -ExcludeType default to *.



> **Type**: ```[Object]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ExcludeType**

If set, will ensure that the script block does not use the types in this list.
Passing -IncludeType without -ExcludeType will make -ExcludeType default to *.



> **Type**: ```[Object]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **NoLoop**

If set, will ensure that the ScriptBlock does not contain any loops.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **NoWhileLoop**

If set, will ensure that the ScriptBlock does not contain any do or while loops.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **AstCondition**

One or more AST conditions to validate.
If no results are found or the condition throws, the script block will be considered invalid.



> **Type**: ```[ScriptBlock[]]```

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
ValidateScriptBlock [-DataLanguage] [-ParameterOnly] [-NoBlock] [-NoParameter] [-IncludeCommand <Object>] [-ExcludeCommand <Object>] [-IncludeType <Object>] [-ExcludeType <Object>] [-NoLoop] [-NoWhileLoop] [-AstCondition <ScriptBlock[]>] [<CommonParameters>]
```
```PowerShell
ValidateScriptBlock [-DataLanguage] [-ParameterOnly] [-NoBlock] [-NoParameter] [-IncludeCommand <Object>] [-ExcludeCommand <Object>] [-IncludeType <Object>] [-ExcludeType <Object>] [-NoLoop] [-NoWhileLoop] [-AstCondition <ScriptBlock[]>] -VariableAST <VariableExpressionAst> [<CommonParameters>]
```
---

