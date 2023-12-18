ModuleExports
-------------

### Synopsis
Gets Module Exports

---

### Description

Gets Exported Commands from a module.

---

### Examples
> EXAMPLE 1

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

|Type              |Required|Position|PipelineInput|
|------------------|--------|--------|-------------|
|`[CommandTypes[]]`|false   |1       |false        |

#### **VariableAST**
A VariableExpression.  This variable must contain a module.

|Type                     |Required|Position|PipelineInput |
|-------------------------|--------|--------|--------------|
|`[VariableExpressionAst]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
ModuleExports [[-CommandType] {Alias | Function | Filter | Cmdlet | ExternalScript | Application | Script | Configuration | All}] [<CommonParameters>]
```
```PowerShell
ModuleExports [[-CommandType] {Alias | Function | Filter | Cmdlet | ExternalScript | Application | Script | Configuration | All}] -VariableAST <VariableExpressionAst> [<CommonParameters>]
```
