Template.Assignment.py
----------------------

### Synopsis
Template for a Python assignment

---

### Description

Template for Python assignment statements.

---

### Examples
> EXAMPLE 1

```PowerShell
Template.Assignment.py -Left "a" -Right 1
```

---

### Parameters
#### **VariableName**
The variable name.

|Type      |Required|Position|PipelineInput        |Aliases             |
|----------|--------|--------|---------------------|--------------------|
|`[String]`|false   |1       |true (ByPropertyName)|Left<br/>Declaration|

#### **ValueExpression**
The value expression

|Type      |Required|Position|PipelineInput|Aliases                             |
|----------|--------|--------|-------------|------------------------------------|
|`[String]`|false   |2       |false        |Right<br/>Expression<br/>Initializer|

#### **AssignmentOperator**
The assignment operator.  By default, =.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |3       |false        |

#### **Indent**
The indentation level.  By default, 0

|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |4       |false        |

---

### Syntax
```PowerShell
Template.Assignment.py [[-VariableName] <String>] [[-ValueExpression] <String>] [[-AssignmentOperator] <String>] [[-Indent] <Int32>] [<CommonParameters>]
```
