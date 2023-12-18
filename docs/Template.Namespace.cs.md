Template.Namespace.cs
---------------------

### Synopsis
Template for CSharp Namespaces

---

### Description

A Template for a CSharp Namespace Definition

---

### Parameters
#### **Namespace**
The namespace.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **Using**
One or more namespace this namespaces will use.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |2       |true (ByPropertyName)|

#### **Body**
The body of the namespace.

|Type        |Required|Position|PipelineInput        |Aliases           |
|------------|--------|--------|---------------------|------------------|
|`[String[]]`|false   |3       |true (ByPropertyName)|Members<br/>Member|

---

### Syntax
```PowerShell
Template.Namespace.cs [[-Namespace] <String>] [[-Using] <String[]>] [[-Body] <String[]>] [<CommonParameters>]
```
