Template.DoLoop.js
------------------

### Synopsis
Template for a JavaScript `do` Loop

---

### Description

Template for a `do` loop in JavaScript.

---

### Examples
> EXAMPLE 1

```PowerShell
Template.DoLoop.js -Condition "false" -Body "console.log('This happens once')"
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
Template.DoLoop.js [[-Condition] <String>] [[-Body] <String>] [<CommonParameters>]
```
