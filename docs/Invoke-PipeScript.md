
Invoke-PipeScript
-----------------
### Synopsis
Invokes PipeScript or PowerShell ScriptBlocks, commands, and syntax.

---
### Description

Runs PipeScript.

Invoke-PipeScript can run any PowerShell or PipeScript ScriptBlock or Command.

Invoke-PipeScript can accept any -InputObject, -Parameter(s), and -ArgumentList.

These will be passed down to the underlying command.

Invoke-PipeScript can also use a number of Abstract Syntax Tree elements as command input:

|AST Type                 |Description                            |
|-------------------------|---------------------------------------|
|AttributeAST             |Runs Attributes                        |
|TypeConstraintAST        |Runs Type Constraints                  |
|InvokeMemberExpressionAst|Runs Member Invocation Expressions     |

---
### Related Links
* [Update-PipeScript](Update-PipeScript.md)



---
### Parameters
#### **InputObject**

The input object.  This will be piped into the underlying command.
If no -Command is provided and -InputObject is a [ScriptBlock]



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByValue)



---
#### **Command**

The Command that will be run.



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:false



---
#### **Parameter**

A collection of named parameters.  These will be directly passed to the underlying script.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ArgumentList**

A list of positional arguments.  These will be directly passed to the underlying script or command.



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **SafeScriptBlockAttributeEvaluation**

If this is not set, when a transpiler's parameters do not take a [ScriptBlock], ScriptBlock values will be evaluated.
This can be a very useful capability, because it can enable dynamic transpilation.
If this is set, will make ScriptBlockAst values will be run within data language, which significantly limits their capabilities.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
Invoke-PipeScript [-InputObject <PSObject>] [[-Command] <PSObject>] [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [-SafeScriptBlockAttributeEvaluation] [<CommonParameters>]
```
---


