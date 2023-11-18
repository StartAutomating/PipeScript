Requires
--------

### Synopsis
requires one or more modules, variables, or types.

---

### Description

Requires will require on or more modules, variables, or types to exist.

---

### Examples
> EXAMPLE 1

```PowerShell
requires latest pipescript  # will require the latest version of pipescript
```
> EXAMPLE 2

```PowerShell
requires variable $pid $sid # will error, because there is no $sid
```

---

### Parameters
#### **Module**
One or more required modules.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Object]`|false   |named   |true (ByPropertyName)|

#### **Latest**
If set, will require the latest version of a module.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **ModuleLoader**
A ModuleLoader script can be used to dynamically load unresolved modules.
This script will be passed the unloaded module as an argument, and should return a module.

|Type           |Required|Position|PipelineInput        |Aliases                                             |
|---------------|--------|--------|---------------------|----------------------------------------------------|
|`[ScriptBlock]`|false   |named   |true (ByPropertyName)|ModuleResolver<br/>Module Loader<br/>Module Resolver|

#### **Type**
One or more required types.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Object]`|false   |named   |true (ByPropertyName)|

#### **TypeLoader**
A TypeLoader script can be used to dynamically load unresolved types.
This script will be passed the unloaded type as an argument.

|Type           |Required|Position|PipelineInput        |Aliases                                       |
|---------------|--------|--------|---------------------|----------------------------------------------|
|`[ScriptBlock]`|false   |named   |true (ByPropertyName)|TypeResolver<br/>Type Loader<br/>Type Resolver|

#### **Variables**
One or more required variables.

|Type      |Required|Position|PipelineInput        |Aliases |
|----------|--------|--------|---------------------|--------|
|`[Object]`|false   |named   |true (ByPropertyName)|Variable|

#### **VariableLoader**
A VariableLoader script can be used to dynamically load unresolved variable.
This script will be passed the unloaded variable as an argument.

|Type           |Required|Position|PipelineInput        |Aliases                                                   |
|---------------|--------|--------|---------------------|----------------------------------------------------------|
|`[ScriptBlock]`|false   |named   |true (ByPropertyName)|VariableResolver<br/>Variable Loader<br/>Variable Resolver|

#### **CommandAst**
The Command AST.  This will be provided when using the transpiler as a keyword.

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[CommandAst]`|true    |named   |true (ByValue)|

#### **ScriptBlock**
The ScriptBlock.  This will be provided when using the transpiler as an attribute.

|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[ScriptBlock]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
Requires [-Module <Object>] [-Latest] [-ModuleLoader <ScriptBlock>] [-Type <Object>] [-TypeLoader <ScriptBlock>] [-Variables <Object>] [-VariableLoader <ScriptBlock>] -CommandAst <CommandAst> [<CommonParameters>]
```
```PowerShell
Requires [-Module <Object>] [-Latest] [-ModuleLoader <ScriptBlock>] [-Type <Object>] [-TypeLoader <ScriptBlock>] [-Variables <Object>] [-VariableLoader <ScriptBlock>] -ScriptBlock <ScriptBlock> [<CommonParameters>]
```
