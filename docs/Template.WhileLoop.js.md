Template.WhileLoop.js
---------------------

### Synopsis
Template for a JavaScript `while` Loop

---

### Description

Template for a `while` loop in JavaScript.

---

### Examples
> EXAMPLE 1

```PowerShell
Template.WhileLoop.js -Condition "false" -Body "console.log('This never happens')"
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

---

### Syntax
```PowerShell
Template.WhileLoop.js [[-Condition] <String>] [[-Body] <String>] [<CommonParameters>]
```
