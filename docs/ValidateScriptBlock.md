
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



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **ParameterOnly**

If set, will ensure that the [ScriptBlock] only has parameters



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **NoBlock**

If set, will ensure that the [ScriptBlock] has no named blocks.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **NoParameter**

If set, will ensure that the [ScriptBlock] has no parameters.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **VariableAST**

A VariableExpression.  If provided, the Validation attributes will apply to this variable.



|Type                         |Requried|Postion|PipelineInput |
|-----------------------------|--------|-------|--------------|
|```[VariableExpressionAst]```|true    |named  |true (ByValue)|
---
### Syntax
```PowerShell
ValidateScriptBlock [-DataLanguage] [-ParameterOnly] [-NoBlock] [-NoParameter] [<CommonParameters>]
```
```PowerShell
ValidateScriptBlock [-DataLanguage] [-ParameterOnly] [-NoBlock] [-NoParameter] -VariableAST <VariableExpressionAst> [<CommonParameters>]
```
---



