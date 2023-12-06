Template.ForLoop.js
-------------------

### Synopsis
Template for a JavaScript ForLoop

---

### Description

Template for a for loop in JavaScript

---

### Examples
> EXAMPLE 1

```PowerShell
Template.ForLoop.js "let step = 0" "step < 5" "step++" 'console.log("walking east one step")'
```
> EXAMPLE 2

```PowerShell
Template.ForLoop.js -Initialization "let step = 0" -Condition "step < 5" -Iterator "step++" -Body '
    console.log("walking east one step")
'
```

---

### Parameters
#### **Initialization**
The For Loop's Initialization.
This initializes the loop.

|Type      |Required|Position|PipelineInput        |Aliases    |
|----------|--------|--------|---------------------|-----------|
|`[String]`|false   |1       |true (ByPropertyName)|Initializer|

#### **Condition**
The For Loop's Condition.
This determine if the loop should continue running.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|

#### **Afterthought**
The For Loop's Iterator, or Afterthought.
This occurs after each iteration of the loop

|Type      |Required|Position|PipelineInput        |Aliases |
|----------|--------|--------|---------------------|--------|
|`[String]`|false   |3       |true (ByPropertyName)|Iterator|

#### **Body**
The body of the loop

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |4       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Template.ForLoop.js [[-Initialization] <String>] [[-Condition] <String>] [[-Afterthought] <String>] [[-Body] <String>] [<CommonParameters>]
```
