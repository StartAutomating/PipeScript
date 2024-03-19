Template.HTML.Parameter.Input
-----------------------------

### Synopsis
Generates an HTML parameter input.

---

### Description

Generates an HTML input element for a parameter.

---

### Parameters
#### **ParameterMetadata**
The Parameter Metadata.  This can be provided via the pipeline from the Parameter.Values of any command.

|Type                 |Required|Position|PipelineInput |
|---------------------|--------|--------|--------------|
|`[ParameterMetadata]`|true    |named   |true (ByValue)|

#### **CommandName**
The name of the command.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **ParameterName**
The name of the parameter.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **ParameterAttribute**
The parameter attributes

|Type          |Required|Position|PipelineInput        |Aliases                 |
|--------------|--------|--------|---------------------|------------------------|
|`[PSObject[]]`|false   |named   |true (ByPropertyName)|Attribute<br/>Attributes|

#### **ParameterType**
The parameter type

|Type    |Required|Position|PipelineInput        |
|--------|--------|--------|---------------------|
|`[Type]`|false   |named   |true (ByPropertyName)|

#### **ParameterHelp**
The parameter help.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **IncludeAutomaticParameter**
If set, the automatic parameters will be included.
(by default, they will be hidden)

|Type      |Required|Position|PipelineInput        |Aliases                   |
|----------|--------|--------|---------------------|--------------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|IncludeAutomaticParameters|

---

### Syntax
```PowerShell
Template.HTML.Parameter.Input [-CommandName <String>] [-ParameterName <String>] [-ParameterAttribute <PSObject[]>] [-ParameterType <Type>] [-ParameterHelp <String>] [-IncludeAutomaticParameter] [<CommonParameters>]
```
```PowerShell
Template.HTML.Parameter.Input -ParameterMetadata <ParameterMetadata> [-CommandName <String>] [-ParameterName <String>] [-ParameterAttribute <PSObject[]>] [-ParameterType <Type>] [-ParameterHelp <String>] [-IncludeAutomaticParameter] [<CommonParameters>]
```
