Template.Class.cs
-----------------

### Synopsis
Template for CSharp Class

---

### Description

A Template for a CSharp Class Definition

---

### Parameters
#### **Class**
The class name.

|Type      |Required|Position|PipelineInput        |Aliases   |
|----------|--------|--------|---------------------|----------|
|`[String]`|false   |1       |true (ByPropertyName)|Identifier|

#### **Modifier**
The class modifiers.  Creates public classes by default.

|Type        |Required|Position|PipelineInput        |Aliases  |
|------------|--------|--------|---------------------|---------|
|`[String[]]`|false   |2       |true (ByPropertyName)|Modifiers|

#### **Attribute**
One or more class attributes

|Type        |Required|Position|PipelineInput        |Aliases                                          |
|------------|--------|--------|---------------------|-------------------------------------------------|
|`[String[]]`|false   |3       |true (ByPropertyName)|Attributes<br/>ClassAttribute<br/>ClassAttributes|

#### **Body**
The body of the class.

|Type        |Required|Position|PipelineInput        |Aliases           |
|------------|--------|--------|---------------------|------------------|
|`[String[]]`|false   |4       |true (ByPropertyName)|Members<br/>Member|

---

### Syntax
```PowerShell
Template.Class.cs [[-Class] <String>] [[-Modifier] <String[]>] [[-Attribute] <String[]>] [[-Body] <String[]>] [<CommonParameters>]
```
