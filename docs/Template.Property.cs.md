Template.Property.cs
--------------------

### Synopsis
Template for CSharp Property

---

### Description

A Template for a CSharp Property Definition

---

### Parameters
#### **Property**
The property name.

|Type      |Required|Position|PipelineInput        |Aliases                             |
|----------|--------|--------|---------------------|------------------------------------|
|`[String]`|false   |1       |true (ByPropertyName)|Identifier<br/>Name<br/>PropertyName|

#### **Modifier**
The class modifiers.  Creates public properties by default.

|Type        |Required|Position|PipelineInput        |Aliases  |
|------------|--------|--------|---------------------|---------|
|`[String[]]`|false   |2       |true (ByPropertyName)|Modifiers|

#### **PropertyType**
The property type.  By default, object.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |3       |true (ByPropertyName)|

#### **Attribute**
One or more property attributes

|Type        |Required|Position|PipelineInput        |Aliases                                                |
|------------|--------|--------|---------------------|-------------------------------------------------------|
|`[String[]]`|false   |4       |true (ByPropertyName)|Attributes<br/>PropertyAttribute<br/>PropertyAttributes|

#### **Body**
The body of the property.

|Type        |Required|Position|PipelineInput        |Aliases           |
|------------|--------|--------|---------------------|------------------|
|`[String[]]`|false   |5       |true (ByPropertyName)|Members<br/>Member|

---

### Syntax
```PowerShell
Template.Property.cs [[-Property] <String>] [[-Modifier] <String[]>] [[-PropertyType] <String>] [[-Attribute] <String[]>] [[-Body] <String[]>] [<CommonParameters>]
```
