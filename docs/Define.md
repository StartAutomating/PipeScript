Define
------
### Synopsis
defines a variable

---
### Description

Defines a variable using a value provided during a build

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    [Define(Value={Get-Random})]$RandomNumber
}.Transpile()
```

#### EXAMPLE 2
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



> **Type**: ```[PSObject]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **VariableAst**

The variable the definition will be applied to.



> **Type**: ```[VariableExpressionAst]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
#### **ScriptBlock**

A scriptblock the definition will be applied to



> **Type**: ```[ScriptBlock]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
#### **VariableName**

The name of the variable.  If define is applied as an attribute of a variable, this does not need to be provided.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
Define -Value <PSObject> -VariableAst <VariableExpressionAst> [-VariableName <String>] [<CommonParameters>]
```
```PowerShell
Define -Value <PSObject> -ScriptBlock <ScriptBlock> [-VariableName <String>] [<CommonParameters>]
```
---

