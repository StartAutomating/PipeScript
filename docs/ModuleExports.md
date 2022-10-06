
ModuleExports
-------------
### Synopsis
Gets Module Exports

---
### Description

Gets Exported Commands from a module.

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    $PipeScriptModule = Get-Module PipeScript
    $exports = [ModuleExports()]$PipeScriptModule
    $exports
}
```

---
### Parameters
#### **CommandType**

The command type



Valid Values:

* Alias
* Function
* Filter
* Cmdlet
* ExternalScript
* Application
* Script
* Configuration
* All



> **Type**: ```[CommandTypes[]]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:false



---
#### **VariableAST**

A VariableExpression.  This variable must contain a module.



> **Type**: ```[VariableExpressionAst]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
ModuleExports [[-CommandType] {Alias | Function | Filter | Cmdlet | ExternalScript | Application | Script | Configuration | All}] [<CommonParameters>]
```
```PowerShell
ModuleExports [[-CommandType] {Alias | Function | Filter | Cmdlet | ExternalScript | Application | Script | Configuration | All}] -VariableAST <VariableExpressionAst> [<CommonParameters>]
```
---



