Protocol.JSONSchema
-------------------

### Synopsis
JSON Schema protocol

---

### Description

Converts a JSON Schema to a PowerShell Script.

---

### Examples
> EXAMPLE 1

```PowerShell
jsonschema https://aka.ms/terminal-profiles-schema#/$defs/Profile
```
> EXAMPLE 2

```PowerShell
{
    [JSONSchema(SchemaURI='https://aka.ms/terminal-profiles-schema#/$defs/Profile')]
    param()
}.Transpile()
```

---

### Parameters
#### **SchemaUri**
The JSON Schema URI.

|Type   |Required|Position|PipelineInput|
|-------|--------|--------|-------------|
|`[Uri]`|true    |named   |false        |

#### **CommandAst**
The Command's Abstract Syntax Tree

|Type          |Required|Position|PipelineInput|
|--------------|--------|--------|-------------|
|`[CommandAst]`|true    |named   |false        |

#### **ScriptBlock**
The ScriptBlock.
This is provided when transpiling the protocol as an attribute.
Providing a value here will run this script's contents, rather than a default implementation.

|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[ScriptBlock]`|true    |named   |true (ByValue)|

#### **RemovePropertyPrefix**
One or more property prefixes to remove.
Properties that start with this prefix will become parameters without the prefix.

|Type        |Required|Position|PipelineInput|Aliases               |
|------------|--------|--------|-------------|----------------------|
|`[String[]]`|false   |named   |false        |Remove Property Prefix|

#### **ExcludeProperty**
One or more properties to ignore.
Properties whose name or description is like this keyword will be ignored.

|Type        |Required|Position|PipelineInput|Aliases                                                              |
|------------|--------|--------|-------------|---------------------------------------------------------------------|
|`[String[]]`|false   |named   |false        |Ignore Property<br/>IgnoreProperty<br/>SkipProperty<br/>Skip Property|

#### **IncludeProperty**
One or more properties to include.
Properties whose name or description is like this keyword will be included.

|Type        |Required|Position|PipelineInput|Aliases         |
|------------|--------|--------|-------------|----------------|
|`[String[]]`|false   |named   |false        |Include Property|

#### **NoMandatory**
If set, will not mark a parameter as required, even if the schema indicates it should be.

|Type      |Required|Position|PipelineInput|Aliases                                                                               |
|----------|--------|--------|-------------|--------------------------------------------------------------------------------------|
|`[Switch]`|false   |named   |false        |NoMandatoryParameters<br/>No Mandatory Parameters<br/>NoMandatories<br/>No Mandatories|

---

### Syntax
```PowerShell
Protocol.JSONSchema -SchemaUri <Uri> -ScriptBlock <ScriptBlock> [-RemovePropertyPrefix <String[]>] [-ExcludeProperty <String[]>] [-IncludeProperty <String[]>] [-NoMandatory] [<CommonParameters>]
```
```PowerShell
Protocol.JSONSchema [-SchemaUri] <Uri> [-RemovePropertyPrefix <String[]>] [-ExcludeProperty <String[]>] [-IncludeProperty <String[]>] [-NoMandatory] [<CommonParameters>]
```
```PowerShell
Protocol.JSONSchema [-SchemaUri] <Uri> -CommandAst <CommandAst> [-RemovePropertyPrefix <String[]>] [-ExcludeProperty <String[]>] [-IncludeProperty <String[]>] [-NoMandatory] [<CommonParameters>]
```
