Template.TryCatch.js
--------------------

### Synopsis
Template for a JavaScript try/catch block

---

### Description

Template for try/catch/finally block in JavaScript.

---

### Examples
> EXAMPLE 1

```PowerShell
Template.TryCatch.js -Try "something that won't work"
```

---

### Parameters
#### **Body**
The body of the try.

|Type        |Required|Position|PipelineInput        |Aliases|
|------------|--------|--------|---------------------|-------|
|`[String[]]`|false   |1       |true (ByPropertyName)|Try    |

#### **Catch**
The catch.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |2       |true (ByPropertyName)|

#### **Finally**
The finally.

|Type        |Required|Position|PipelineInput        |Aliases          |
|------------|--------|--------|---------------------|-----------------|
|`[String[]]`|false   |3       |true (ByPropertyName)|Cleanup<br/>After|

#### **ExceptionVariable**
The exception variable.  By default `e`.

|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[String]`|false   |4       |false        |exv    |

---

### Notes
By default, exceptions are given the variable `e`.

To change this variable, set -ExceptionVariable

---

### Syntax
```PowerShell
Template.TryCatch.js [[-Body] <String[]>] [[-Catch] <String[]>] [[-Finally] <String[]>] [[-ExceptionVariable] <String>] [<CommonParameters>]
```
