JSONSchema.Protocol
-------------------
### Synopsis
json schema protocol

---
### Description

Converts a json schema to PowerShell.

---
### Examples
#### EXAMPLE 1
```PowerShell
jsonschema https://aka.ms/terminal-profiles-schema#/$defs/Profile
```

#### EXAMPLE 2
```PowerShell
{
    [JSONSchema(SchemaURI='https://aka.ms/terminal-profiles-schema#/$defs/Profile')]
    param()
}.Transpile()
```

---
### Parameters
#### **SchemaUri**

The URI.



> **Type**: ```[Uri]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **CommandAst**

The Command's Abstract Syntax Tree



> **Type**: ```[CommandAst]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **ScriptBlock**

> **Type**: ```[ScriptBlock]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
#### **RemovePropertyPrefix**

One or more property prefixes to remove.
Properties that start with this prefix will become parameters without the prefix.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ExcludeProperty**

One or more properties to ignore.
Properties whose name or description is like this keyword will be ignored.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **IncludeProperty**

One or more properties to include.
Properties whose name or description is like this keyword will be included.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **NoMandatory**

If set, will not mark a parameter as required, even if the schema indicates it should be.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
JSONSchema.Protocol -SchemaUri <Uri> -ScriptBlock <ScriptBlock> [-RemovePropertyPrefix <String[]>] [-ExcludeProperty <String[]>] [-IncludeProperty <String[]>] [-NoMandatory] [<CommonParameters>]
```
```PowerShell
JSONSchema.Protocol -SchemaUri <Uri> -CommandAst <CommandAst> [-RemovePropertyPrefix <String[]>] [-ExcludeProperty <String[]>] [-IncludeProperty <String[]>] [-NoMandatory] [<CommonParameters>]
```
---

