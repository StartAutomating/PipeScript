Template.Assignment.js
----------------------

### Synopsis
Template for a JavaScript assignment

---

### Description

Template for JavaScript assignment statements.

---

### Examples
> EXAMPLE 1

```PowerShell
Template.Assignment.js -Left "a" -Right 1
```
> EXAMPLE 2

```PowerShell
Template.Const.js -VariableName "MyConstant" -Expression 42
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

#### **Const**
If set, the assignment will be constant

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **Variant**
If set, the assignment will be a variant.

|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[Switch]`|false   |named   |false        |Var    |

#### **Let**
If set, the assignment will be a locally scoped let.

|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[Switch]`|false   |named   |false        |Local  |

#### **AssignmentOperator**
The assignment operator.  By default, =.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |3       |false        |

---

### Syntax
```PowerShell
Template.Assignment.js [[-VariableName] <String>] [[-ValueExpression] <String>] [-Const] [-Variant] [-Let] [[-AssignmentOperator] <String>] [<CommonParameters>]
```
