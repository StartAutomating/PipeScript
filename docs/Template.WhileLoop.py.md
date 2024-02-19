Template.WhileLoop.py
---------------------

### Synopsis
Template for a Python `while` Loop

---

### Description

Template for a `while` loop in Python.

---

### Examples
> EXAMPLE 1

```PowerShell
Template.WhileLoop.py -Condition "false" -Body 'print("This never happens")'
```

---

### Parameters
#### **Condition**
The Loop's Condition.
This determines if the loop should continue running.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **Body**
The body of the loop

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|

#### **BodyIndent**
The number of spaces to indent the body.
By default, two.

|Type     |Required|Position|PipelineInput        |
|---------|--------|--------|---------------------|
|`[Int32]`|false   |3       |true (ByPropertyName)|

#### **Indent**
The number of spaces to indent all code.
By default, zero

|Type     |Required|Position|PipelineInput        |
|---------|--------|--------|---------------------|
|`[Int32]`|false   |4       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Template.WhileLoop.py [[-Condition] <String>] [[-Body] <String>] [[-BodyIndent] <Int32>] [[-Indent] <Int32>] [<CommonParameters>]
```
