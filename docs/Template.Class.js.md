Template.Class.js
-----------------

### Synopsis
Template for a JavaScript `class`

---

### Description

Template for a `class` in JavaScript.

---

### Examples
> EXAMPLE 1

```PowerShell
Template.Class.js -Name "MyClass" -Body "MyMethod() { return 'hello'}"
```

---

### Parameters
#### **Name**
The name of the function.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **Body**
The body of the function.

|Type        |Required|Position|PipelineInput        |Aliases           |
|------------|--------|--------|---------------------|------------------|
|`[String[]]`|false   |2       |true (ByPropertyName)|Member<br/>Members|

#### **Extend**
If provided, will extend from a base class.

|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[String]`|false   |3       |false        |Extends|

---

### Syntax
```PowerShell
Template.Class.js [[-Name] <String>] [[-Body] <String[]>] [[-Extend] <String>] [<CommonParameters>]
```
