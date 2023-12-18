Template.Method.cs
------------------

### Synopsis
Template for CSharp Method

---

### Description

A Template for a CSharp Method Definition

---

### Parameters
#### **Method**
The method name.

|Type      |Required|Position|PipelineInput        |Aliases                           |
|----------|--------|--------|---------------------|----------------------------------|
|`[String]`|false   |1       |true (ByPropertyName)|Identifier<br/>Name<br/>MethodName|

#### **Modifier**
The method modifiers.  Creates public methods by default.

|Type        |Required|Position|PipelineInput        |Aliases  |
|------------|--------|--------|---------------------|---------|
|`[String[]]`|false   |2       |true (ByPropertyName)|Modifiers|

#### **ReturnType**
The return type.  By default, void.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |3       |true (ByPropertyName)|

#### **Attribute**
One or more method attributes

|Type        |Required|Position|PipelineInput        |Aliases                                            |
|------------|--------|--------|---------------------|---------------------------------------------------|
|`[String[]]`|false   |4       |true (ByPropertyName)|Attributes<br/>MethodAttribute<br/>MethodAttributes|

#### **Body**
The body of the method.

|Type        |Required|Position|PipelineInput        |Aliases           |
|------------|--------|--------|---------------------|------------------|
|`[String[]]`|false   |5       |true (ByPropertyName)|Members<br/>Member|

---

### Syntax
```PowerShell
Template.Method.cs [[-Method] <String>] [[-Modifier] <String[]>] [[-ReturnType] <String>] [[-Attribute] <String[]>] [[-Body] <String[]>] [<CommonParameters>]
```
