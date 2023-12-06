Template.ForEachLoop.js
-----------------------

### Synopsis
Template for a JavaScript `for (..in..)` Loop

---

### Description

Template for a `for (..in..)` loop in JavaScript.

---

### Examples
> EXAMPLE 1

```PowerShell
Template.ForEachLoop.js "variable" "object" 'statement'
```

---

### Parameters
#### **Variable**
The For Loop's Initialization.
This initializes the loop.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **Condition**
The For Loop's Condition.
This determine if the loop should continue running.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|

#### **Body**
The body of the loop

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |3       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Template.ForEachLoop.js [[-Variable] <String>] [[-Condition] <String>] [[-Body] <String>] [<CommonParameters>]
```
