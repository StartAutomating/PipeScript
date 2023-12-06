Template.Function.js
--------------------

### Synopsis
Template for a JavaScript `function`

---

### Description

Template for a `function` in JavaScript.

---

### Examples
> EXAMPLE 1

```PowerShell
Template.Function.js -Name "Hello" -Body "return 'hello'"
```

---

### Parameters
#### **Name**
The name of the function.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **Argument**

|Type        |Required|Position|PipelineInput        |Aliases                               |
|------------|--------|--------|---------------------|--------------------------------------|
|`[String[]]`|false   |2       |true (ByPropertyName)|Arguments<br/>Parameter<br/>Parameters|

#### **Body**
The body of the function.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |3       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Template.Function.js [[-Name] <String>] [[-Argument] <String[]>] [[-Body] <String[]>] [<CommonParameters>]
```
