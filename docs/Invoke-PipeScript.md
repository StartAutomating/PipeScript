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

---

### Related Links
* [Use-PipeScript](Use-PipeScript.md)

* [Update-PipeScript](Update-PipeScript.md)

---

### Examples
PipeScript is a superset of PowerShell.
So a hello world in PipeScript is the same as a "Hello World" in PowerShell:

```PowerShell
Invoke-PipeScript { "hello world" } # Should -Be "Hello World"
```
Invoke-PipeScript will invoke a command, ScriptBlock, file, or AST element as PipeScript.

```PowerShell
Invoke-PipeScript { all functions } # Should -BeOfType ([Management.Automation.FunctionInfo])
```

---

### Parameters
#### **InputObject**
The input object.  This will be piped into the underlying command.
If no -Command is provided and -InputObject is a [ScriptBlock]

|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[PSObject]`|false   |named   |true (ByValue)|

#### **Command**
The Command that will be run.

|Type        |Required|Position|PipelineInput|Aliases                                                                               |
|------------|--------|--------|-------------|--------------------------------------------------------------------------------------|
|`[PSObject]`|false   |1       |false        |ScriptBlock<br/>CommandName<br/>CommandInfo<br/>AttributeSyntaxTree<br/>TypeConstraint|

#### **Parameter**
A collection of named parameters.  These will be directly passed to the underlying script.

|Type           |Required|Position|PipelineInput|Aliases   |
|---------------|--------|--------|-------------|----------|
|`[IDictionary]`|false   |named   |false        |Parameters|

#### **ArgumentList**
A list of positional arguments.  These will be directly passed to the underlying script or command.

|Type          |Required|Position|PipelineInput|Aliases  |
|--------------|--------|--------|-------------|---------|
|`[PSObject[]]`|false   |named   |false        |Arguments|

#### **OutputPath**
The OutputPath.
If no -OutputPath is provided and a template file is invoked, an -OutputPath will be automatically determined.
This currently has no effect if not invoking a template file.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **SafeScriptBlockAttributeEvaluation**
If this is not set, when a transpiler's parameters do not take a [ScriptBlock], ScriptBlock values will be evaluated.
This can be a very useful capability, because it can enable dynamic transpilation.
If this is set, will make ScriptBlockAst values will be run within data language, which significantly limits their capabilities.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

---

### Syntax
```PowerShell
Invoke-PipeScript [-InputObject <PSObject>] [[-Command] <PSObject>] [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [-OutputPath <String>] [-SafeScriptBlockAttributeEvaluation] [<CommonParameters>]
```
